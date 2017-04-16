class Company < ActiveRecord::Base
  acts_as_commentable
  resourcify
  has_paper_trail on: [:create]

  mount_uploader :logo, LogoUploader

  has_many :interviews
  has_many :company_reps
  has_many :users, through: :company_reps
  has_many :jobs
  belongs_to :industry
  has_many :favorites, as: :owner
  has_many :favorited_candidates, through: :favorites, source: :subject, source_type: 'Candidate'
  has_many :followings, class_name: 'Favorite', as: :subject

  validates :name, presence: true, uniqueness: true, length: {minimum: 3}

  validates_presence_of :company_reps
  validates_presence_of :industry_id, :about_us, :street_address, :country_iso3, :city, :postal_code, on: :update

  scope :created, -> { where(state: 'created') }
  scope :pending, -> { where(state: 'pending') }
  scope :accepted, -> { where(state: 'accepted') }
  scope :with_jobs, -> { includes(:jobs).where(jobs: {state: 'published'}).where.not(jobs: { id: nil }) }
  scope :followed_by, -> (user) { includes(:followings).where(favorites: {owner_id: user.id}).where.not(favorites: { id: nil }) }

  state_machine :state, :initial => :created do
    state :created
    state :pending
    state :rejected
    state :accepted
    state :banned

    event :submit do
      transition :created => :pending, if: :logo_set?
    end

    event :reject do
      transition :pending => :rejected
    end

    event :accept do
      transition :pending => :accepted
    end

    event :ban do
      transition :accepted => :banned
    end

    event :unban do
      transition :banned => :accepted
    end

    after_transition any => :pending, :do => :send_pending_mails
    after_transition any => :accepted, :do => :send_accepted_mail

    after_transition do |company,transition|
      company.versions.create(item_type: 'Company', item_id: company.id, event: transition.event.to_s)
    end
  end

  def logo_set?
    !self.logo.url.nil?
  end

  def send_pending_mails
    self.users.each do |user|
      CompanyRepMailer.delay.pending_email(self, user)
    end
    StaffMailer.delay.pending_company_email(self)
  end

  def send_accepted_mail
    self.users.each do |user|
      CompanyRepMailer.delay.accepted_email(self, user)
    end
  end

  def self.order_by_transition_date(reverse = false)
    self.joins(:versions).where('versions.created_at = (SELECT MAX(versions.created_at) FROM versions WHERE versions.item_id = companies.id)').group('companies.id').order("MAX(versions.created_at) #{reverse ? 'desc' : 'asc'}")
  end
end
