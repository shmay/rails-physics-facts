class FactSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :impressions_count

  def attributes
    data = super

    data[:tag_names] = object.tag_names if object.respond_to?(:tag_names)
    data[:user_vote] = object.user_vote if object.respond_to?(:user_vote)
    data[:starred] = object.starred if object.respond_to?(:starred)
    data[:votes_count] = object.votes_count if object.respond_to?(:votes_count)

    data
  end

end
