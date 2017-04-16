class StaffLightCandidateSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_avatar_url, :user_id

  def user_avatar_url
    object.user.avatar_url
  end
end
