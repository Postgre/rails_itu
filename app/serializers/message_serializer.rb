class MessageSerializer < ActiveModel::Serializer
  attributes :id, :subject, :body, :created_at, :updated_at
  has_one :sender, serializer: UserSerializer
end
