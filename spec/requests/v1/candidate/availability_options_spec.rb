require 'rails_helper'

describe 'Candidate' do

  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }

  context 'get list of availability options' do

    before do
      login_as(user, :scope => :user)
      get '/api/v1/availability-options', {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'should get list availability options' do
      response_body = json(response.body)
      expect(response_body).to eq(Candidate::AVAILABILITY_OPTIONS)
    end
  end

end
