class EmploymentRecord < ActiveRecord::Base
  default_scope { order('start_date ASC') }
  belongs_to :candidate

  validates :candidate_id, presence: true
  validates :start_date , presence: true
  validates :job_title , presence: true
  validates :description , presence: true
  validates :city , presence: true
  validates :country_iso3, presence: true
  validates :company_name , presence: true
  validate :at_least_end_date_or_is_current_job

  def at_least_end_date_or_is_current_job
    if [self.end_date, self.is_current_job].reject(&:blank?).size == 0
      errors[:base] << I18n.t('activerecord.errors.models.employment_record.attributes.end_date.not_available_when_no_is_current_job')
    end
  end
end
