class CurrentUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :avatar_url, :email, :unread_messages_count

  has_many :roles, serializer: RoleSerializer

  def unread_messages_count
    object.mailbox.conversations(read: false).count(:id, distinct: true)
  end
end
