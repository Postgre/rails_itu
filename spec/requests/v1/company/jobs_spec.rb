require 'rails_helper'

describe 'Job' do
  let(:interview)         { create :interview, :in_itu }
  let(:job)               { Job.find interview.job_id }
  let(:company)           { Company.find job.company_id }
  let(:user)              { User.find company.users.first.id }
  let(:candidate)         { Candidate.find interview.candidate.id }
  let(:wrong_user)        { create :user }
  let!(:private_job)       { FactoryGirl.create(:job, company: company, is_public: false) }

  context '#index' do
    before do
      login_as(user, :scope => :user)
      FactoryGirl.create_list(:job, 10, company: company)
      get "/api/v1/companies/#{company.id}/jobs", {}
    end

    context 'owner' do
      it 'list all company jobs' do
        expect(response).to be_success
        response_body = json(response.body)
        expect(response_body.length).to eq(12)
        expect(response_body.map{|r| r[:is_public]}.uniq).to include(false)
      end
    end

    context 'non-owner' do
      before do
        login_as(wrong_user, :scope => :user)
        get "/api/v1/companies/#{company.id}/jobs", {}
      end

      it 'returns only visible jobs' do
        expect(response).to be_success
        response_body = json(response.body)
        expect(response_body.length).to eq(11)
        expect(response_body.map{|r| r[:is_public]}.uniq).to eq([true])
      end
    end
  end

  context '#show' do
    before do
      login_as(user, :scope => :user)
      FactoryGirl.create_list(:job, 10, company: company)
    end

    context 'non-owner' do
      before do
        login_as(wrong_user, :scope => :user)
        get "/api/v1/companies/#{company.id}/jobs/#{job.id}", {}
      end

      it 'get success response' do
        expect(response).to be_success
      end

      it 'shows job details' do
        response_body = json(response.body)
        expect(response_body[:title]).to eq(job.title)
      end
    end
  end

  context '#show for non-public job' do
    context 'non-owner' do
      before do
        login_as(wrong_user, :scope => :user)
        get "/api/v1/companies/#{company.id}/jobs/#{private_job.id}", {}
      end

      it 'returns 403 status code' do
        expect(response.status).to eql(403)
      end
    end

    context 'interview candidate' do
      before do
        login_as(candidate.user, :scope => :user)
        FactoryGirl.create(:interview, company: company, candidate: candidate, job: private_job)
        get "/api/v1/companies/#{company.id}/jobs/#{private_job.id}", {}
      end

      it 'get success response' do
        expect(response).to be_success
      end

      it 'shows job details' do
        response_body = json(response.body)
        expect(response_body[:title]).to eq(private_job.title)
      end
    end

    context 'owner' do
      before do
        login_as(user, :scope => :user)
        get "/api/v1/companies/#{company.id}/jobs/#{private_job.id}", {}
      end

      it 'get success response' do
        expect(response).to be_success
      end

      it 'shows job details' do
        response_body = json(response.body)
        expect(response_body[:title]).to eq(private_job.title)
      end
    end
  end

  context '#create' do
    context 'successfully' do
      before do
        login_as(user, :scope => :user)
        job = FactoryGirl.attributes_for(:job)
        post "/api/v1/companies/#{company.id}/jobs", {
          job: {
            title: 'Ruby On Rails Developer',
            description: 'Building cool apps',
            work_type: 'on_site',
            schedule: 'part_time',
            start_date: Date.today + 10.days,
            years: 2,
            company_id: company.id,
            user_id: user.id,
          }}.to_json, json_content_type(user.access_token)
      end

      it 'creates job and returns a successful response' do
        expect(response).to be_success
        expect(json(response.body)[:title]).to eq('Ruby On Rails Developer')
      end

      it 'new job have open state' do
        expect(json(response.body)[:state]).to eq('draft')
      end
    end

    context 'unsuccessfully' do
      before do
        login_as(user, :scope => :user)
        post "/api/v1/companies/#{company.id}/jobs", {job: {title: nil}}.to_json, json_content_type
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end

      it 'returns JSON with error messages' do
        response_body = json(response.body)
        expect(response_body[:title]).to eql(["can't be blank"])
      end

    end
  end

  context '#update' do
    context 'successfully' do
      before do
        login_as(user, :scope => :user)
        patch "/api/v1/companies/#{company.id}/jobs/#{job.id}", {job: {title: 'Ruby Developer'}}.to_json, json_content_type
      end

      it 'should update job and return a successful json response' do
        expect(response).to be_success
        expect(job.reload.title).to eql('Ruby Developer')
      end
    end

    context 'unsuccessfully' do
      before do
        login_as(user, :scope => :user)
        patch "/api/v1/companies/#{company.id}/jobs/#{job.id}", {job: {work_type: nil}}.to_json, json_content_type
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end

      it 'returns JSON with error messages' do
        response_body = json(response.body)
        expect(response_body[:work_type]).to eql(["can't be blank"])
      end
    end
  end
end
