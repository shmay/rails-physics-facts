class Fact < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :votes, dependent: :destroy

  attr_accessor :tag_list

  after_save :check_tags

  def check_tags
    tag_list = tag_list.split(',') if tag_list.class == String

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

  def self.find_with_stats(id)
    id = id.to_i

    query = <<-SQL
      with fact_w_votes as (
        select facts.id, coalesce(sum(votes.dir),0) as votes_count
        from facts
        left join votes on votes.fact_id = facts.id
        where facts.id = #{id} 
        group by facts.id
      )

      select facts.id, facts.title, facts.body, facts.user_id, facts.created_at,
        fact_w_votes.votes_count, users.username, ARRAY_AGG(tags.name) AS tag_names 

      from facts
      inner join users on users.id = facts.user_id
      inner join taggings on taggings.fact_id = facts.id
      inner join tags on tags.id = taggings.tag_id
      left join fact_w_votes on fact_w_votes.id = facts.id
      where facts.id = #{id} 

      group by facts.id, fact_w_votes.votes_count, users.username
    SQL

    self.find_by_sql(query).first
  end

  def self.all_with_stats
    query = <<-SQL
      with facts_w_votes as (
      select facts.id, coalesce(sum(votes.dir),0) as votes_count
      from facts
      left join votes on votes.fact_id = facts.id
      group by facts.id)

      select facts.id, facts.title, facts.body, facts.user_id, facts.created_at,
        facts_w_votes.votes_count, users.username, ARRAY_AGG(tags.name) AS tag_names 

      from facts
      inner join users on users.id = facts.user_id
      inner join taggings on taggings.fact_id = facts.id
      inner join tags on tags.id = taggings.tag_id
      left join facts_w_votes on facts_w_votes.id = facts.id

      group by facts.id, facts_w_votes.votes_count, users.username
    SQL

    self.find_by_sql(query)
  end

end
