class StaffCommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :parent_id, :created_at, :commentable_type, :commentable_id

  has_one :user, serializer: StaffUserSerializer
  has_many :children, serializer: StaffCommentSerializer
end
