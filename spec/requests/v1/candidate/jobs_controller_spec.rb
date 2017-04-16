require 'rails_helper'

describe 'API::V1::Candidate::JobsController' do

  let(:company)   { FactoryGirl.create(:company) }
  let(:candidate) { FactoryGirl.create(:candidate, :john) }
  let(:job)       { FactoryGirl.create(:job, company: company, is_public: false) }

  context '#index' do
    context "when there aren't any jobs" do
      before :each do
        login_as(candidate.user, :scope => :user)
        get '/api/v1/candidate/jobs', {}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it 'returns an empty JSON array' do
        expect(response.body).to eq('[]')
      end
    end

    context 'when there are jobs' do
      before :each do
        login_as(candidate.user, :scope => :user)
        job.update_attribute :is_public, true
        get '/api/v1/candidate/jobs', {}, json_content_type
      end

      it 'returns a non-empty JSON array' do
        expect(response.body).not_to eq('[]')
      end

      it 'returns a JSON array containing the created job' do
        job = Job.last
        serialized_job = CandidateJobSerializer.new(job, scope: candidate.user).serializable_hash

        # forcing unmatched skill count to be 0
        serialized_job[:unmatched_skill_count] = 0

        expect(response.body).to eq([serialized_job].to_json)
      end
    end
  end

  context '#show' do
    context "when it's not a visible job" do
      before do
        login_as(candidate.user, :scope => :user)
        get "/api/v1/candidate/jobs/#{job.id}", {}, json_content_type
      end

      it 'returns a forbidden response' do
        expect(response).to be_forbidden
      end

      it 'returns an empty response' do
        expect(response.body).to be_blank
      end
    end

    context "when it's a visible job" do
      before do
        login_as(candidate.user, :scope => :user)
        job.update_attribute(:is_public, true)
        get "/api/v1/candidate/jobs/#{job.id}", {}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it 'returns a JSON array containing the created job' do
        job = Job.last
        expect(response.body).to eq(CandidateJobSerializer.new(job, scope: candidate.user).serializable_hash.to_json)
      end
    end

  end


  context '#recommended' do
    context "where there aren't any public jobs" do
      before :each do
        login_as(candidate.user, :scope => :user)
        get '/api/v1/candidate/jobs/recommended', {}, json_content_type
      end

      it 'returns an empty JSON array' do
        expect(response.body).to eq('[]')
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end
    end

    context "where there aren't any recommended jobs" do
      before :each do
        login_as(candidate.user, :scope => :user)
        get '/api/v1/candidate/jobs/recommended', {}, json_content_type
      end

      it 'returns an empty JSON array' do
        expect(response.body).to eq('[]')
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end
    end

    context "where there are recommended jobs" do
      let(:staff) { FactoryGirl.create(:user, :staff) }
      before :each do
        login_as(candidate.user, :scope => :user)

        job.update_attribute(:is_public, true)

        candidate.favorites.create(creator_id: staff.id, subject_id: job.id, subject_type: 'Job')

        get '/api/v1/candidate/jobs/recommended', {}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it 'returns an non-empty JSON array' do
        expect(response.body).not_to eq('[]')
      end

      it 'returns a JSON array containing the created and recommended Job' do
        job = Job.last
        serialized_job = CandidateJobSerializer.new(job, scope: candidate.user).serializable_hash

        # forcing unmatched skill count to be 0
        serialized_job[:unmatched_skill_count] = 0

        expect(response.body).to eq([serialized_job].to_json)
      end

    end

  end

  context '#favorite' do
    context "when a job isn't starred by a user" do
      before :each do
        login_as(candidate.user, :scope => :user)
        put "/api/v1/candidate/jobs/#{job.id}/favorite", {}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it "adds a favorite entry" do
        expect(candidate.favorites.size).to eq(1)
      end

      it "marks a job as starred for the given user" do
        expect(candidate.favorites.first.subject_type).to eq('Job')
        expect(candidate.favorites.first.subject_id).to eq(job.id)
      end
    end

    context "when a job is already starred by a user" do
      before :each do
        login_as(candidate.user, :scope => :user)
        candidate.favorites.where(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job').first_or_create
        put "/api/v1/candidate/jobs/#{job.id}/favorite", {}, json_content_type
      end

      it 'returns a successful response' do
        expect(response).to be_success
      end

      it "doesn't add another favorite entry" do
        expect(candidate.favorites.size).to eq(1)
      end
    end

  end

  context '#unfavorite' do
    before :each do
      login_as(candidate.user, :scope => :user)
      candidate.favorites.where(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job').first_or_create
      delete "/api/v1/candidate/jobs/#{job.id}/favorite", {}, json_content_type
    end

    it "unmarks a job as starred for the given user" do
      expect(candidate.favorites).to be_blank
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end
  end
end
