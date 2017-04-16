require 'rails_helper'

describe 'API' do
  let(:company) { FactoryGirl.create :company, :itu }

  context 'non public route' do
    before do
      get "/api/v1/companies/#{company.id}/jobs",
        {},
        {
          'Accept' => Mime::JSON,
          'Content-Type' => Mime::JSON.to_s
        }
    end

    it 'returns 401 status code' do
      expect(response.status).to eql(401)
    end

    it 'returns content_type as JSON' do
      expect(response.content_type).to eql(Mime::JSON)
    end

    it 'returns JSON with bad credentials message' do
      expect(json(response.body)[:error]).to eql('You need to sign in or sign up before continuing.')
    end
  end

end
