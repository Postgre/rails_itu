class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :subject, :receipts, :is_read, :updated_at
  has_one :last_responder, serializer: UserSerializer

  def receipts
    object.receipts_for(scope).map do |receipt|
      ReceiptSerializer.new(receipt, scope: scope)
    end
  end

  def is_read
    !object.receipts_for(scope).map(&:is_read).include?(false)
  end

  def last_responder
    object.receipts_for(scope).last.message.sender
  end
end
