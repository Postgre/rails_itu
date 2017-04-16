class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :avatar_url, :user_type

  def user_type
    return 'Candidate' unless object.candidate.nil?
    return 'Staff' if object.has_role? :staff
    'CompanyRep'
  end
end
