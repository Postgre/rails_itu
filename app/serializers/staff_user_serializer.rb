class StaffUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :avatar_url, :email, :user_type, :comments_size, :candidate_id,
             :last_sign_in_at

  has_many :roles, serializer: StaffRoleSerializer
  has_many :comments, serializer: CommentSerializer

  def user_type
    return 'Candidate' unless object.candidate.nil?
    return 'Staff' if object.has_role? :staff
    'CompanyRep'
  end

  def comments
    object.root_comments
  end

  def comments_size
    object.comment_threads.size
  end

  def candidate_id
    object.try(:candidate).try(:id)
  end
end
