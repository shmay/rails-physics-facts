require 'byebug'

class Fact < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :votes, dependent: :destroy

  is_impressionable :counter_cache => true

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { minimum: 10 }

  validate :has_tag

  attr_accessor :tag_list

  after_save :check_tags

  def has_tag
    if !self.tag_list || self.tag_list.length == 0
      errors.add(:base, 'must have at least one tag')
    end
  end

  def check_tags
    tag_list = self.tag_list

    tag_list = tag_list.split(',') if tag_list && tag_list.class == String

    if tag_list
      self.taggings.delete_all

      tag_list.each do |tag|
        t = Tag.find_by_name tag.strip
        if not t
          t = Tag.create name:tag
        end
        Tagging.create fact_id:self.id, tag_id:t.id
      end
    end
  end

  def self.shallow_facts(user_id)
    query = fact_query(nil, user_id, true)

    self.find_by_sql(query.to_sql)
  end

  def self.find_with_stats(id, user_id)
    query = fact_query(id, user_id)

    self.find_by_sql(query.to_sql).first
  end

  def self.all_with_stats(user_id = nil)
    query = fact_query(nil, user_id)

    self.find_by_sql(query.to_sql)
  end

  def self.find_w_votes(id, user_id)
    Fact.facts_w_votes(user_id).
      where(%{facts.id = ?}, id).first
  end

  def self.facts_w_votes(user_id)
    selects = [
      'facts.id', 
      'coalesce(sum(votes.dir),0) as votes_count',
    ]

    if user_id
      s = "sum(case WHEN votes.user_id = #{user_id} THEN votes.dir else 0 END) as user_vote" 
      selects << s
    end

    select(selects).
    joins(%{left join votes on votes.fact_id = facts.id}).
    group('facts.id')
  end

  private

  def self.fact_query(id,user_id, shallow = nil)
    query = with(facts_w_votes: Fact.facts_w_votes(user_id)).
    select(get_selects(user_id, shallow)).
    joins(get_joins(user_id))

    groups = [
      'facts.id', 'users.username',
      'facts_w_votes.votes_count'
    ]

    if user_id
      groups << 'facts_w_votes.user_vote'
    end

    if id
      query = query.where('facts.id = ?',id)
    end

    query = query.group(groups).order('created_at desc')

    query
  end

  def self.get_selects(user_id, shallow)
    selects = [
      'facts.id', 'facts.impressions_count', 'facts.title', 'facts.user_id',
        'facts.created_at', 'facts_w_votes.votes_count', 'users.username',
        'ARRAY_AGG(tags.name) AS tag_names']

    if !shallow
      selects << 'facts.body'
    end

    if user_id
      selects << 'facts_w_votes.user_vote, count(distinct(starrings.id)) as starred'
    end

    selects
  end

  def self.get_joins(user_id)
    joins = [
      "inner join users on users.id = facts.user_id",
      "inner join taggings on taggings.fact_id = facts.id",
      "inner join tags on tags.id = taggings.tag_id",
      "left join facts_w_votes on facts_w_votes.id = facts.id"
    ]

    if user_id
      joins << "left join starrings on starrings.fact_id = facts.id and starrings.user_id = #{user_id}"
    end

    joins
  end

end
