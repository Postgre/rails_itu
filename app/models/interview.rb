class Interview < ActiveRecord::Base
  acts_as_commentable
  has_paper_trail

  belongs_to :company
  belongs_to :job
  belongs_to :candidate

  validates :company_id,   presence: true
  validates :job_id,       presence: true
  validates :candidate_id, presence: true
  validates :date,         presence: true
  validates :location,     presence: true
  validate :job_is_published

  geocoded_by :location
  after_validation :geocode

  scope :hired, -> { where(state: 'hired') }
  scope :accepted, -> { where(state: 'accepted') }

  def job_is_published
    unless self.try(:job).try(:published?)
      errors.add(:job, I18n.t('errors.messages.interview.job_need_to_be_published'))
    end
  end

  state_machine :state, :initial => :offered do
    state :offered
    state :rejected
    state :accepted
    state :time_rejected
    state :cancelled
    state :hired

    event :accept do
      transition :offered => :accepted
    end

    event :reject do
      transition [:offered, :accepted, :time_rejected] => :rejected
    end

    event :cancel do
      transition [:offered, :accepted, :time_rejected] => :cancelled
    end

    event :reject_time do
      transition :offered => :time_rejected
    end

    event :change_time do
      transition :time_rejected => :offered
    end

    event :hire do
      transition :accepted => :hired
    end

    state :offered, :reject_time, :change_time do
      validates_datetime  :date, after: -> { Time.now }
      validates_datetime  :suggested_date, after: -> { Time.now },
                          allow_nil: true
    end

    after_transition :offered => :accepted, :do => :send_accepted_mail
    after_transition any => :rejected, :do => :send_rejected_mail
    after_transition :offered => :time_rejected, :do => :send_rejected_mail
    after_transition any => :cancelled, :do => :send_interview_canceled_mail
    after_transition any => :cancelled, :do => :cancel_application
    after_transition any => :hired, :do => :do_hiring_actions
    after_transition :time_rejected => :accepted, :do => :send_time_confirmed_mail
  end

  after_create :send_interview_invite

  def send_interview_invite
    CandidateMailer.delay.interview_invite_email(self)
  end

  def send_accepted_mail
    self.company.users.each do |user|
      CompanyRepMailer.delay.interview_accepted_email(self, user)
    end
  end

  def send_rejected_mail
    self.company.users.each do |user|
      CompanyRepMailer.delay.interview_rejected_email(self, user)
    end
  end

  def send_time_rejected_mail
    self.company.users.each do |user|
      CompanyRepMailer.delay.interview_rejected_email(self, user)
    end
  end

  def send_interview_canceled_mail
    CandidateMailer.delay.interview_canceled_email(self)
  end

  def cancel_application
    self.job.job_applications.where(candidate_id: self.candidate.id).first.try(:reject) #TODO: suppress second mail
  end

  def send_hired_email
    CandidateMailer.delay.hired_email(self)
  end

  def send_time_confirmed_mail
    CandidateMailer.delay.time_confirmed_email(self)
  end

  def do_hiring_actions
    self.send_hired_email
    self.job.fill
  end
end
