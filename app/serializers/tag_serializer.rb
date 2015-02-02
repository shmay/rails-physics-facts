class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :created_at
end
