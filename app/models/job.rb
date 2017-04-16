class Job < ActiveRecord::Base
  searchkick
  acts_as_commentable
  has_paper_trail

  WORK_TYPE            = [{value: 'remote', name: 'Remote'},
                          {value: 'on_site', name: 'Onsite'},
                          {value: 'mixed', name: 'Mixed (Remote+Onsite)'},
                          {value: 'internship', name: 'Internship'}]
  enum work_type: { remote: 0, on_site: 1, mixed: 2, internship: 3, }

  SCHEDULE           = [{value: 'full_time', name: 'Full-time'},
                        {value: 'part_time', name: 'Part-time'}]
  enum schedule: { full_time: 0, part_time: 1 }

  belongs_to :company

  has_many :skill_records, -> { order(:position) }, as: :skillable
  has_many :skills, through: :skill_records
  has_many :skill_category_records,  -> { order(:position) }, as: :skill_categorizable, class_name: 'SkillCategoryRecord'
  has_many :skill_categories, through: :skill_category_records
  has_many :interviews
  has_many :candidates, through: :interviews
  has_many :favorites, as: :subject
  has_many :favorited_candidates, through: :favorites, source: :owner, source_type: 'Candidate'
  has_many :job_applications

  geocoded_by :location
  after_validation :geocode

  accepts_nested_attributes_for :skill_records

  scope :with_interviews, -> (cond) { cond ? includes(:interviews).where.not(interviews: { id: nil }) : includes(:interviews).where(interviews: { id: nil }) }
  scope :visible, -> { where(state: 'published', is_public: true) }

  validates :title, presence: true
  validates :description, presence: true
  # validates :years, presence: true
  validates :company_id, presence: true
  validates :work_type, presence: true
  validates :schedule, presence: true
  validate :start_date_cannot_be_in_past, on: :create

  def start_date_cannot_be_in_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end

  delegate :name, to: :company, allow_nil: nil
  alias_method :company_name, :name

  state_machine :state, :initial => :draft do
    state :draft
    state :published
    state :filled
    state :closed
    state :flagged do
      validate :validate_no_interviews
    end

    after_transition do |job, transition|
      job.update_attribute(:last_state_change_at, DateTime.now)
    end

    after_transition :draft => :published do |job|
      job.update_attribute :published_at, DateTime.now
    end

    event :publish do
      transition :draft => :published
    end

    event :fill do
      transition :published => :filled
    end

    event :archive do
      transition :published => :closed
    end

    event :flag do
      transition :published => :flagged, if: :no_interviews
    end
  end

  def no_interviews
    self.interviews.size == 0
  end

  def validate_no_interviews
    if self.interviews.size > 0
      self.errors.add(:base, I18n.t('errors.messages.job.interviews_found'))
    end
  end

  def search_data
    attributes.merge(
      skill_name: skills.pluck(:name),
      skill_category_name: skill_categories.pluck(:name),
    )
  end

  def self.search_all(options={})
    lookup(options[:query],
      where: {
        skill_name: options[:skill_name],
        skill_category_name: options[:skill_category_name],
        schedule: options[:schedule],
        work_type: options[:work_type]
      },
      facets: [
          :skill_name,
          :skill_category_name,
          :schedule,
          :work_type
        ]
      )
  end

  def recommended
    return [] unless self.skill_records.size > 0
    Candidate.where(id: Rails::Redis.sunion(self.skill_records.map{|r| "skill:#{r.skill_id}:Candidate:ids"}))
        .where.not(id: self.company.users.map(&:candidate).compact!.try(:map, &:id), is_visible: false)
  end

  def self.orderable_by_skill_match(candidate)
    candidate_skill_ids = Rails::Redis.smembers("Candidate:#{candidate.id}:skills")
    return self.select('jobs.*, 0 as unmatched_skill_count') if candidate_skill_ids.empty?

    self.joins(left_join_on_skill_records_excluding_candidate_skill_ids(candidate_skill_ids))
        .select('jobs.*, count(s_records.skill_id) as unmatched_skill_count')
        .group('jobs.id')
  end

  def self.matched_for_candidate(candidate)
    candidate_skill_ids = Rails::Redis.smembers("Candidate:#{candidate.id}:skills")
    return [] if candidate_skill_ids.empty?
    Job.where(id: Rails::Redis.sunion(candidate_skill_ids.map {|skill_id| "skill:#{skill_id}:Job:ids"}))
        .joins("LEFT OUTER JOIN skill_records AS sr_unmatched ON sr_unmatched.skillable_type='Job' AND sr_unmatched.skillable_id=jobs.id")
        .select('jobs.*, count(sr_unmatched.skill_id) as unmatched_skill_count')
        .group('jobs.id')
  end

  def self.staff_recommended_for_candidate(candidate)
    joins(:favorites).where(favorites: {owner: candidate}).where.not(favorites: {creator_id: [candidate.user.id]})
  end

  def self.recommended_for_candidate(candidate)
    matched = self.matched_for_candidate(candidate).where_values.reduce(:and)
    favorites = self.staff_recommended_for_candidate(candidate).where_values.reduce(:and)
    joins("LEFT OUTER JOIN skill_records AS sr_unmatched ON sr_unmatched.skillable_type='Job' AND sr_unmatched.skillable_id=jobs.id")
                        .select('jobs.*, count(sr_unmatched.skill_id) as unmatched_skill_count')
                        .joins(:favorites)
                        .where(matched.or(favorites))
                        .where.not(favorites: {creator_id: [candidate.user.id]})
                        .group('jobs.id')
  end

  def self.starred_by_candidate(candidate)
    joins(:favorites).where(favorites: {owner: candidate}).where(favorites: {creator_id: [candidate.user.id]})
  end

  private

    def self.left_join_on_skill_records_excluding_candidate_skill_ids candidate_skill_ids
      skill_join =  "LEFT JOIN skill_records as s_records ON s_records.skillable_id = jobs.id AND s_records.skillable_type = 'Job'"
      skill_join += " AND s_records.skill_id NOT IN (#{candidate_skill_ids.join(',')})" if candidate_skill_ids && candidate_skill_ids.size > 0
      skill_join
    end

end
