require 'rails_helper'

describe 'Interviews' do
  let(:interview)         { create :interview, :in_itu }
  let(:job)               { Job.find interview.job_id }
  let(:company)           { Company.find job.company_id }
  let(:user)              { User.find company.users.first.id }
  let(:candidate)         { Candidate.find interview.candidate.id }
  let(:candidate_user)    { User.find interview.candidate.user.id }
  let(:another_interview) { create :interview, job: job, company: company }
  let(:wrong_user)        { create :user }

  context 'without logged user' do
    context 'list Interviews' do
      before do
        get "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews",{}, json_content_type
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

  context 'with logged user' do
    context 'list Interviews' do
      before do
        login_as(user, :scope => :user)
        get "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews", {},json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'returns content_type as JSON' do
        expect(response.content_type).to eql(Mime::JSON)
      end

      it 'returns JSON with interview data' do
        response_body = json(response.body)
        expect(response_body.first[:location]).to eql(interview.location)
      end
    end

    context 'show Interview information' do
      context 'to owner' do
        before do
          login_as(user, :scope => :user)
          get "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews/#{interview.id}",{}, json_content_type
        end

        it 'returns 200 status code' do
          expect(response).to be_success
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with interview data' do
          i = json(response.body)
          expect(i[:location]).to eql(interview.location)
        end
      end

      context 'to correct candidate' do
        before do
          login_as(candidate_user, :scope => :user)
          get "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews/#{interview.id}",{}, json_content_type
        end

        it 'returns 200 status code' do
          expect(response).to be_success
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with interview data' do
          i = json(response.body)
          expect(i[:location]).to eql(interview.location)
        end
      end

      context 'to wrong candidate' do
        before do
          login_as(another_interview.candidate.user, :scope => :user)
          get "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews/#{interview.id}",{}, json_content_type
        end

        it 'returns 403 status code' do
          expect(response.status).to eql(403)
        end
      end
    end

    context '#create' do
      context 'successfully' do
        before do
          login_as(user, :scope => :user)
          post "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews",
            { interview: {
                company_id: interview.company_id,
                candidate_id: interview.candidate_id,
                date: 2.days.from_now.to_s,
                location: 'Company will contact you on Skype'
              }
            }.to_json,
            json_content_type
        end

        it 'returns success code' do
          expect(response).to be_success
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with interview data' do
          interview = json(response.body)
          expect(interview[:location]).to eql('Company will contact you on Skype')
        end

        it 'new interview have offered state' do
          interview = json(response.body)
          expect(interview[:state]).to eql('offered')
        end
      end

      context 'unsuccessfully' do
        before do
          login_as(user, :scope => :user)
          post "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews",
            { interview: {
                company_id: interview.company_id,
                candidate_id: interview.candidate_id,
                date: 2.days.from_now.to_s,
                location: nil
              }
            }.to_json,
            json_content_type
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with error data' do
          errors = json(response.body)
          expect(errors[:location]).to eql(["can't be blank"])
        end
      end
    end

    context '#update' do
      context 'by owner' do
        context 'successfully' do
          before do
            login_as(user, :scope => :user)
            patch "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews/#{interview.id}",
              { interview: { location: 'Google Hangout' } }.to_json, json_content_type
          end

          it 'returns 200 status code' do
            expect(response.status).to eql(200)
          end

          it 'returns content_type as JSON' do
            expect(response.content_type).to eql(Mime::JSON)
          end

          it 'updates existing interview location' do
            expect(interview.reload.location).to eql('Google Hangout')
          end
        end

        context 'unsuccessfully' do
          before do
            @now = Time.zone.now
            Timecop.freeze(@now)
            login_as(user, :scope => :user)
            patch "/api/v1/companies/#{company.id}/jobs/#{job.id}/interviews/#{interview.id}",
              { interview: { date: 1.day.ago.to_s } }.to_json, json_content_type
          end

          after { Timecop.return }

          it 'returns 422 status code' do
            expect(response.status).to eql(422)
          end

          it 'returns content_type as JSON' do
            expect(response.content_type).to eql(Mime::JSON)
          end

          it 'returns JSON with error data' do
            errors = json(response.body)
            expect(errors[:date]).to eql(["must be after #{@now.strftime('%Y-%m-%d %H:%M:%S')}"])
          end
        end
      end
    end
  end
end
