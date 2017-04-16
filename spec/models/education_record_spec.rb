require 'rails_helper'

describe EducationRecord do
  subject(:education_record) {  FactoryGirl.create(:education_record)  }

  it { should validate_presence_of(:candidate_id) }
  it { should validate_presence_of(:school) }
  it { should validate_presence_of(:start_year) }
  it { should validate_presence_of(:region) }
  it { should validate_presence_of(:country_iso3) }
  it { should validate_presence_of(:city) }

  it 'should require degree if end year is set' do
    education_record.end_year = Time.current.year
    education_record.degree = nil

    education_record.valid? # trigger validation to run (without saving)

    expect(education_record.errors[:base]).to include I18n.t('activerecord.errors.models.education_record.attributes.degree.not_available_when_end_year_set')
  end
end
