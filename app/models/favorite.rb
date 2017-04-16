class Favorite < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :creator, class_name: 'User'

  after_create :send_mail

  def send_mail
    return unless self.subject.is_a? Job
    return unless self.creator.has_role? :staff
    return if self.creator_id == self.owner.user_id
    CandidateMailer.delay.recommended_job_email(self)
  end
end
