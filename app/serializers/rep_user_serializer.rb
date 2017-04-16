class RepUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :avatar_url, :email
end
