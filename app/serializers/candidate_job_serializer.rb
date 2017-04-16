class CandidateJobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :years, :work_type, :schedule, :start_date,
             :state, :is_public, :is_favorited, :created_at, :location, :latitude, :longitude,
             :recommendation_data, :last_state_change_at, :unmatched_skill_count, :is_applied, :application_state

  has_one :company, serializer: CandidateCompanySerializer
  has_many :skill_records, serializer: SkillRecordSerializer
  has_many :skill_category_records, serializer: SkillCategoryRecordSerializer
  has_one :job_application, serializer: JobApplicationSerializer

  def job_application
    return unless scope.candidate
    scope.candidate.job_applications.where(job_id: object.id).first
  end

  def is_favorited
    return nil unless scope.candidate
    scope.candidate.favorites.where(subject_id: object.id, creator_id: scope.id, owner_id: scope.candidate.id).any?
  end

  def possible_events
    object.state_events
  end

  def recommended_candidates_count
    object.recommended.size
  end

  def recommendation_data
    return nil unless scope.candidate
    FavoriteJobSerializer.new(scope.candidate.favorites.where(subject_id: object.id, owner_id: scope.candidate.id).where.not(creator_id: scope.id).last)
  end

  def unmatched_skill_count
    object.try(:unmatched_skill_count)
  end

  def is_applied
    return nil unless scope.candidate
    scope.candidate.job_applications.where(job_id: object.id).any?
  end

  def application_state
    return nil unless scope.candidate
    scope.candidate.job_applications.where(job_id: object.id).first.try(:state)
  end
end
