require 'rails_helper'

describe 'CandidateSkills', broken: true do
  subject { create(:skill) }

  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }


  describe "#tree" do

    before do
      Rails::Redis.hset(user.access_token, 'itu_id', user.itu_id)
      allow(candidate).to receive(:skill_category_records).and_return([create(:skill_category_record, skill_categorizable: candidate)])
      @scr = candidate.skill_category_records.first.skill_category
      @skill = create(:skill, skill_category: @scr)
      FactoryGirl.create_list(:skill_record, 5, skillable: candidate, skill: @skill)

      get '/api/v1/candidate/skill-records/tree', {}, json_content_type(user.itu_id)
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "should return 5 skill record tree" do
        response_body =  json(response.body)
        expect(response_body.first[:skill_records].size).to eq(5)
    end
  end
end
