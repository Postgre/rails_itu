class ReceiptSerializer < ActiveModel::Serializer
  attributes :id, :receiver_id, :receiver_type, :created_at, :updated_at, :is_read
  has_one :message, serializer: MessageSerializer
end
