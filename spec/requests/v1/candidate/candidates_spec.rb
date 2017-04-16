require 'rails_helper'

describe 'Candidate' do

  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }

  context '#show' do
    before do
      login_as(user, :scope => :user)
      get '/api/v1/candidate', {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'show candidate information' do
      expect(response).to match_response_schema('candidate')
    end
  end

  context '#update' do
    context 'successfully' do
      before do
        login_as(user, :scope => :user)
        patch '/api/v1/candidate', {candidate: {availability: 0}}.to_json, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it 'should update candidate and return a successful json response' do
        response_body = json(response.body)
        expect(response_body[:availability]).to eq('not_available')
      end
    end
  end

  context '#search' do
    context 'successfully' do
      before do
        login_as(user, :scope => :user)
        get '/api/v1/candidates/search', {query: 'Ruby'}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end
    end
  end
end
