class FactSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :impressions_count, :user_id

  def attributes
    data = super

    data[:tag_list] = object.tag_names if object.respond_to?(:tag_names)
    data[:body] = object.body if object.respond_to?(:body)
    data[:user_vote] = object.user_vote if object.respond_to?(:user_vote)
    data[:starred] = object.starred if object.respond_to?(:starred)
    data[:votes_count] = object.votes_count if object.respond_to?(:votes_count)

    data
  end

end
