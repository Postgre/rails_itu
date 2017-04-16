class EducationRecord < ActiveRecord::Base
  default_scope { order('start_year ASC') }

  belongs_to :candidate, touch: true

  validates :candidate_id, presence:  true
  validates :start_year , presence: true
  validates :school , presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :country_iso3, presence: true

  validate :degree_if_end_year_set

  def degree_if_end_year_set
    if !self.end_year.blank?
      if self.degree.blank?
        errors[:base] << I18n.t('activerecord.errors.models.education_record.attributes.degree.not_available_when_end_year_set')
      end
    end
  end
end
