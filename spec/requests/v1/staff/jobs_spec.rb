require 'rails_helper'

describe 'Jobs' do
  let(:candidate) { create :candidate, :john }
  let(:staff) { create :user, :staff }
  let(:job) { create :job }
  let(:closed_job) { create :job, :closed }
  let(:interview) { create :interview, :in_itu }

  context 'active' do
    context 'favorite' do
      before do
        login_as(staff, :scope => :user)
        patch "/api/v1/staff/jobs/#{job.id}/recommend", {user_id: candidate.user.id}.to_json, json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'adds favorite' do
        expect(candidate.favorited_jobs.where(id: job.id)).to exist
      end
    end

    context 'unfavorite' do
      before do
        login_as(staff, :scope => :user)
        candidate.favorites.where(creator_id: staff.id, subject_id: job.id, subject_type: 'Job').first_or_create
        delete "/api/v1/staff/jobs/#{job.id}/recommend", {user_id: candidate.user.id}.to_json, json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'removes favorite' do
        expect(candidate.favorited_jobs.where(id: job.id)).not_to exist
      end
    end
  end

  context 'inactive' do
    before do
      login_as(staff, :scope => :user)
      patch "/api/v1/staff/jobs/#{closed_job.id}/recommend", {user_id: candidate.user.id}.to_json, json_content_type
    end

    it 'returns 422 status code' do
      expect(response.status).to eql(422)
    end

    it 'not adding favorite' do
      expect(candidate.favorited_jobs.where(id: job.id)).not_to exist
    end
  end

  context 'already favorited by user' do
    before do
      login_as(staff, :scope => :user)
      candidate.favorites.where(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job').first_or_create
      delete "/api/v1/staff/jobs/#{job.id}/recommend", {user_id: candidate.user.id}.to_json, json_content_type
    end

    it 'returns 422 status code' do
      expect(response.status).to eql(200)
    end

    it 'leaves favorite' do
      expect(candidate.favorited_jobs.where(id: job.id)).to exist
    end
  end

  context 'flag' do
    context 'successfully' do
      before do
        login_as(staff, :scope => :user)
        patch "/api/v1/staff/jobs/#{job.id}/flag", {}, json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'flag job' do
        expect(job.reload.state).to eql('flagged')
      end
    end

    context 'unsuccessfully' do
      before do
        login_as(staff, :scope => :user)
        patch "/api/v1/staff/jobs/#{interview.job.id}/flag", {}, json_content_type
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end

      # it 'returns JSON with validation error' do
      #   response_body = json(response.body)
      #   expect(response_body[:errors][:base]).to eql([I18n.t('errors.messages.job.interviews_found')])
      # end

      it 'not flag job' do
        expect(job.reload.state).to eql('published')
      end
    end
  end
end