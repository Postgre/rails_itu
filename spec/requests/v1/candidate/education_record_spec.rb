require 'rails_helper'

describe 'EducationRecord' do
  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }

  describe '#index' do
    before do
      FactoryGirl.create_list(:education_record, 10, candidate: candidate)
      login_as(user, :scope => :user)
      get "/api/v1/candidate/education-records/", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "return list of all education histories" do
      expect(json(response.body).length).to eq(10)
    end

  end


  describe '#create' do
    before do
      FactoryGirl.create_list(:education_record, 10, candidate: candidate)
      login_as(user, :scope => :user)
      post "/api/v1/candidate/education-records/", {
          school: "International Technological University",
          city: "San Francisco",
          field_of_study: "Economics",
          degree: "B.Com",
          start_year: 5.years.from_now,
          end_year: 2.years.ago,
          country_iso3: 'USA',
          region: 'California'
      }.to_json, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "return the created education record" do
        response_body = json(response.body)
        expect(response_body[:school]).to eq("International Technological University")
    end

  end

  describe '#show' do
    subject {create(:education_record, candidate: candidate) }

    before do
      login_as(user, :scope => :user)
      get "/api/v1/candidate/education-records/#{subject.id}", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "returns a valid education history record" do
      response_body = json(response.body)
      expect(response_body[:school]).to eql(subject.school)
    end
  end

  describe '#update' do
   subject {create(:education_record, candidate: candidate) }

   context 'when a valid record is submitted' do
      before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/education-records/#{subject.id}", {school: 'ITU 2'}.to_json, json_content_type
      end

      it 'returns a succesful response' do
        expect(response).to be_success
      end

      it 'returns record with updated school name' do
       response_body = json(response.body)
       expect(response_body[:school]).to eql('ITU 2')
      end
    end

    context 'when invalid record is submitted' do
      before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/education-records/#{subject.id}", {school: nil}.to_json, json_content_type
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end

      it 'returns content_type as JSON' do
        expect(response.content_type).to eql(Mime::JSON)
      end

      it 'returns error messages' do
        errors = json(response.body)
        expect(errors[:school]).to eql(["can't be blank"])
      end
    end

  end

  describe '#destroy' do
    subject {create(:education_record, candidate: candidate) }

    context 'when a record exists' do
      before do
        login_as(user, :scope => :user)
        delete "/api/v1/candidate/education-records/#{subject.id}",{}, json_content_type
      end

      it 'returns 204 status code' do
        expect(response.status).to eql(204)
      end
    end
  end

end
