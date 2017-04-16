require 'rails_helper'

describe SkillCategoryRecord do

  context 'object validations' do
    subject {create(:skill_category_record, :candidate_skill_category_record)}
    it {should validate_presence_of(:skill_category_id)}
    it {should validate_presence_of(:skill_categorizable_id)}
    it {should validate_presence_of(:skill_categorizable_type)}
  end

  context 'Candidate skill_category_record' do
    subject {FactoryGirl.create(:skill_category_record, :candidate_skill_category_record)}

    it 'includes associated candidate user' do
      expect(subject.skill_categorizable).to be_a Candidate
    end
  end

  context 'Job skill_category_record' do
    subject {FactoryGirl.create(:skill_category_record, :job_skill_category_record)}

    it 'includes associated job' do
      expect(subject.skill_categorizable).to be_a Job
    end
  end
end
