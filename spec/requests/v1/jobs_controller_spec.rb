require 'rails_helper'

describe 'API::V1::JobsController' do

  let(:company)   { FactoryGirl.create(:company) }
  let(:user)      { FactoryGirl.create(:user) }
  let(:job)       { FactoryGirl.create(:job, company: company) }

  context '#index' do
    context "when there aren't any jobs" do
      before :each do
        login_as(user, :scope => :user)
        get '/api/v1/jobs', {}, json_content_type
      end

      it 'returns an empty JSON array' do
        expect(response.body).to eq('[]')
      end
    end

    context 'when there are jobs' do
      before :each do
        login_as(user, :scope => :user)
        job.update_attribute :is_public, true
        get '/api/v1/jobs', {}, json_content_type
      end

      it 'returns a non-empty JSON array' do
        expect(response.body).not_to eq('[]')
      end

      it 'returns a JSON array containing the created job' do
        job = Job.last
        expect(response.body).to eq([JobSerializer.new(job, scope: user).serializable_hash].to_json)
      end
    end
  end

  context '#show' do
    before do
      login_as(user, :scope => :user)
      get "/api/v1/jobs/#{job.id}", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'returns a JSON array containing the created job' do
      job = Job.last
      expect(response.body).to eq(JobSerializer.new(job, scope: user).serializable_hash.to_json)
    end
  end
end
