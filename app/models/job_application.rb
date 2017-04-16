class JobApplication < ActiveRecord::Base
  resourcify
  has_paper_trail

  mount_uploader :resume, ResumeUploader

  belongs_to :job
  belongs_to :candidate

  validates :job, associated: true
  validates :candidate, associated: true
  validates :cover_letter, presence: true
  validates :resume, presence: true

  delegate :company_name, :title, to: :job, allow_nil: nil
  alias_method :job_title, :title

  state_machine :state, :initial => :created do
    state :created
    state :rejected
    state :accepted

    event :send_to_rep do
      transition :created => :sent #  , if: :resume_set?
    end

    event :accept do
      transition :created => :accepted
    end

    event :reject do
      transition [:created, :accepted] => :rejected
    end

    after_transition any => :rejected, :do => :send_rejected_application_email
  end

  after_create :send_new_application_email

  def send_new_application_email
    self.job.company.users.each do |user|
      CompanyRepMailer.delay.new_application_email(self, user)
    end
  end

  def send_rejected_application_email
    CandidateMailer.delay.rejected_application_email(self)
  end
end
