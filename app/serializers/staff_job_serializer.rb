class StaffJobSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :title, :description, :years, :work_type, :schedule, :start_date,
             :state, :is_public, :is_favorited, :created_at, :possible_events, :recommended_candidates_count,
             :applied_candidates_count, :location, :latitude, :longitude, :created_at, :updated_at, :published_days_ago,
             :published_at, :favorited_candidates

  has_one :company, serializer: StaffCompanySerializer
  has_many :comments, serializer: StaffCommentSerializer
  has_many :skill_records, serializer: SkillRecordSerializer
  has_many :skill_category_records, serializer: SkillCategoryRecordSerializer

  def favorited_candidates
    object.favorites.map do |favorite|
      if ((favorite.creator_id == favorite.owner.user_id) && (favorite.owner_type == 'Candidate')) || (favorite.owner_type != 'Candidate')
        nil
      else
        StaffLightCandidateSerializer.new(favorite.owner)
      end
    end.compact
  end

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

  def comments
    object.root_comments
  end

  def comments_size
    object.comment_threads.size
  end

  def published_days_ago
    return nil unless object.published_at
    time_ago_in_words(object.published_at)
  end
end
