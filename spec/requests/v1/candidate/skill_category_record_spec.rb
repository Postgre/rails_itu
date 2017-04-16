require 'rails_helper'

describe 'SkillCategoryRecord' do

  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }

  describe '#index' do
    before do
      login_as(user, :scope => :user)
      allow(candidate).to receive(:skill_category_records).and_return([create(:skill_category_record, skill_categorizable: candidate)])
      get '/api/v1/candidate/skill-category-records', {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'return a list of all skill category records' do
      expect(json(response.body).length).to eq(2)
    end
  end

  describe '#remove' do
    subject {create(:skill_category_record, skill_categorizable: candidate) }

    context 'remove skill category record' do
      before do
        login_as(user, :scope => :user)
        delete "/api/v1/candidate/skill-category-records/#{subject.skill_category_id}", {}, json_content_type
      end

      it 'returns 204 status code' do
        expect(response.status).to eql(204)
      end
    end
  end

end
