require 'rails_helper'

describe 'EmpoymentRecord' do
  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }

  describe '#index' do
    before do
      FactoryGirl.create_list(:employment_record, 10, candidate: candidate)
      login_as(user, :scope => :user)
      get '/api/v1/candidate/employment-records/', {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'return a list of all employment_records' do
      response_body = json(response.body)
      expect(response_body.size).to eq(10)
    end

  end

  describe '#show' do
    subject { create(:employment_record, candidate: candidate) }

    before do
      login_as(user, :scope => :user)
      get "/api/v1/candidate/employment-records/#{subject.id}", {}
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'returns a valid subject' do
      response_body = json(response.body)
      expect(response_body[:company_name]).to eql(subject.company_name)
    end
  end

  describe '#update' do
   subject {create(:employment_record, candidate: candidate)}

   context 'when a valid record is submitted' do
      before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/employment-records/#{subject.id}", { company_name: 'ITU 2' }.to_json, json_content_type
      end

      it 'returns a succesful response' do
        expect(response).to be_success
      end

      it 'returns record with updated school name' do
       response_body = json(response.body)
       expect(response_body[:company_name]).to eql('ITU 2')
      end
    end

    context 'when invalid record is submitted' do
      before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/employment-records/#{subject.id}", { company_name: nil }.to_json, json_content_type
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end

      it 'returns content_type as JSON' do
        expect(response.content_type).to eql(Mime::JSON)
      end

      it 'returns error messages' do
        errors = json(response.body)
        expect(errors[:company_name]).to eql(["can't be blank"])
      end
    end

  end

  describe '#destroy' do
    subject {create(:employment_record, candidate: candidate) }

    context 'when a record exists' do
      before do
        login_as(user, :scope => :user)
        delete "/api/v1/candidate/employment-records/#{subject.id}",{},json_content_type
      end

      it 'returns 204 status code' do
        expect(response.status).to eql(204)
      end
    end
  end

end
