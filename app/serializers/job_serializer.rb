class JobSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :title, :description, :years, :work_type, :schedule, :start_date,
             :state, :is_public, :is_favorited, :created_at, :possible_events, :recommended_candidates_count,
             :location, :latitude, :longitude, :last_state_change_at, :applied_candidates_count, :published_days_ago

  has_many :skill_records, serializer: SkillRecordSerializer
  has_many :skill_category_records, serializer: SkillCategoryRecordSerializer
  has_one :company, serializer: CompanySerializer

  def is_favorited
    return false unless scope.candidate
    scope.candidate.favorites.where(subject_id: object.id).any?
  end

  def possible_events
    object.state_events
  end

  def recommended_candidates_count
    object.recommended.size
  end

  def applied_candidates_count
    object.job_applications.where(state: ['created', 'accepted']).size
  end

  def published_days_ago
    return nil unless object.published_at
    time_ago_in_words(object.published_at)
  end
end
