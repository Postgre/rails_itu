require 'rails_helper'

describe EmploymentRecord do
  subject(:employment_record) { FactoryGirl.create(:employment_record) }

  it { should validate_presence_of(:candidate_id) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:job_title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country_iso3) }

  it 'should require at least end date or is_current_job' do
    employment_record.end_date = nil
    employment_record.is_current_job = nil

    employment_record.valid? # trigger validation to run (without saving)

    expect(employment_record.errors[:base]).to include I18n.t('activerecord.errors.models.employment_record.attributes.end_date.not_available_when_no_is_current_job')

    employment_record.end_date = nil
    employment_record.is_current_job = false

    employment_record.valid?

    expect(employment_record.errors[:base]).to include I18n.t('activerecord.errors.models.employment_record.attributes.end_date.not_available_when_no_is_current_job')

    employment_record.end_date = Time.current
    employment_record.is_current_job = nil
    expect(employment_record.valid?).to be true

    employment_record.end_date = nil
    employment_record.is_current_job = true
    expect(employment_record.valid?).to be true
  end
end
