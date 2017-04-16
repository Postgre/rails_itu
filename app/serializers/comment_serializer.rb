class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :parent_id, :created_at, :commentable_type, :commentable_id

  has_one :user, serializer: UserSerializer
  has_many :children, serializer: CommentSerializer
end
