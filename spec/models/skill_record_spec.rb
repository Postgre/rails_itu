require 'rails_helper'

describe SkillRecord do
  subject {create(:skill_record, :candidate_skill_record)}
  it {should validate_presence_of(:skill_id)}
  it {should validate_presence_of(:years_of_experience)}
  it {should validate_presence_of(:level)}

  context 'Candidate skill_record' do
    subject {FactoryGirl.create(:skill_record, :candidate_skill_record)}

    it 'includes associated candidate user' do
      expect(subject.skillable).to be_a Candidate
    end

  end

  context 'Job skill_record' do
    subject {FactoryGirl.create(:skill_record, :job_skill_record)}
    
    it 'includes associated job' do
      expect(subject.skillable).to be_a Job
    end
  end
end
