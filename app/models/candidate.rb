class Candidate < ActiveRecord::Base
  acts_as_commentable

  AVAILABILITY_OPTIONS = [
      { value: 'not_available', name: 'Not available' },
      { value: 'available_full_time', name: 'Available for full-time' },
      { value: 'available_part_time', name: 'Available for part-time only' }
  ]

  belongs_to :user
  enum availability: { not_available: 0, available_part_time: 1, available_full_time: 2 }

  has_many :education_records
  has_many :employment_records

  has_many :skill_records, -> { order(:position) }, as: :skillable, class_name: 'SkillRecord'
  has_many :skills, through: :skill_records

  has_many :interviews
  has_many :jobs, through: :interviews
  has_many :skill_category_records, -> { order(:position) }, as: :skill_categorizable, class_name: 'SkillCategoryRecord'
  has_many :skill_categories, through: :skill_category_records

  has_many :favorites, as: :owner
  has_many :favorited_jobs, through: :favorites, source: :subject, source_type: 'Job'

  has_many :job_applications

  has_many :courses

  validates :user_id, presence: true
  validates :user_id, uniqueness: true, presence: true

  after_touch :set_is_profile_complete

  delegate :email, :full_name, to: :user, allow_nil: nil
  alias_method :name, :full_name

  scope :visible, -> { where(is_visible: true) }
  scope :available, -> { where.not(availability: 0) }
  scope :profile_complete, -> { where(is_profile_complete: true) }

  searchkick

  def search_data
    attributes.merge(
      skill_name: skills.pluck(:name),
      skill_category_name: skill_categories.pluck(:name),
      degree: education_records.pluck(:degree),
      years_of_experience: skill_records.pluck(:years_of_experience)
    )
  end

  def degree
    recent_degree ||= education_records.last.try(:degree)
  end

  def set_is_profile_complete
    self.update_attribute :is_profile_complete, ((self.education_records.size > 0) && (self.skill_records.size > 0) && !self.about.blank?)
  end

  def self.years_of_experience_ranges
    [
      {from: 1, to: 2},
      {from: 3, to: 5},
      {from: 6, to: 10},
      {from: 10}
    ]
  end

  def self.do_search(options={})
    page     = options.delete(:page) || 1
    per_page = options.delete(:per_page) || 50

    # nuke nil options
    conditions = {
      skill_name: options[:skill_name],
      skill_category_name: options[:skill_category_name],
      availability: options[:availability]
    }.reject!{|k,v| v.blank?}

    search = Candidate.lookup(options[:query],
      where: conditions,
      facets: [
          :skill_name,
          :degree,
          :years_of_experience,
          :availability
        ],
      include: [:skills, :skill_categories, :education_records],
      page: page, per_page: per_page
    )
    CandidateSearchDecorator.new(search)
  end

  def recommended
    Job.where(id: Rails::Redis.sinter(self.skill_records.map{|r| "skill:#{r.skill_id}:Job:ids"}))
  end

  def is_visible_locked
    (self.interviews.pluck(:state) & %w(offered accepted time_rejected)).size > 0
  end

  def self.matching_job_skills job
    Candidate.where(id: Rails::Redis.sinter(job.skill_ids.map{|s| "skill:#{s}:Candidate:ids"}))
  end
end
