class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :about, :is_visible, :city, :availability, :name, :country_iso3, :country, :region, :is_favorited,
             :is_invited, :is_visible_locked, :skill_records, :percent, :job_match_position, :interview_state

  has_one :user
  has_many :skill_category_records, serializer: SkillCategoryRecordSerializer
  has_many :education_records, serializes: EducationRecord
  has_many :employment_records, serializes: EmploymentRecord

  def attributes
    if @options[:token]
      super.except(:employment_records, :interview_state, :is_visible, :is_visible_locked, :availability, :job_match_position, :percent, :is_favorited, :is_invited)
    else
      super
    end
  end

  def skill_records
    object.skill_records.map do |skill_record|
      SkillRecordSerializer.new(skill_record, scope: scope)
    end
  end

  def country
    { id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name) }
  end

  def name
    [object.user.first_name, object.user.middle_name, object.user.last_name].join(' ')
  end

  def is_favorited
    return false unless scope.is_a? Job
    scope.company.favorites.where(subject_id: object.id).any?
  end

  def is_invited
    return scope.interviews.where(candidate_id: object.id).any? if scope.is_a? Job
    return object.interviews.any? if scope.is_a? User
  end

  def interview_state
    return scope.interviews.where(candidate_id: object.id).first.try(:state) if scope.is_a? Job
  end

  def percent
    return 0 unless scope.is_a? Job
    return 0 if scope.skill_records.size == 0
    ((scope.skill_records.pluck(:skill_id) & object.skill_records.pluck(:skill_id)).size / scope.skill_records.size.to_f * 100.0).round
  end

  def job_match_position
    return 0 unless scope.is_a? Job

    skill_records = scope.skill_records

    return 0 unless scope.skill_records.size > 0

    # TODO improve the following line
    Rails::Redis.del("scores-job-#{scope.id}")

    Rails::Redis.zunionstore("scores-job-#{scope.id}",
                             skill_records.map { |sr| "skill:#{sr.skill_id}:Candidate:scores" },
                             weights: scope.skill_records.map(&:position))
    Rails::Redis.zrank("scores-job-#{scope.id}", object.id)
  end
end
