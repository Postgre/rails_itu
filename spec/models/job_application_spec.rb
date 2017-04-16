require 'rails_helper'

describe JobApplication do
  subject { FactoryGirl.build(:job_application) }

  it { should be_valid }
  it { should belong_to(:job) }
  it { should belong_to(:candidate) }

  # context 'validations' do TODO: fixme
  #   it { should validate_presence_of(:job_id) }
  #   it { should validate_presence_of(:candidate_id) }
  #   it { should validate_presence_of(:resume) }
  #   it { should validate_presence_of(:cover_letter) }
  # end
end
