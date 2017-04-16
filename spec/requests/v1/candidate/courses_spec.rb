require 'rails_helper'

describe 'Course' do
  let(:candidate) { FactoryGirl.create :candidate, :john }
  let(:user) { User.find candidate.user_id }
  let(:course) { FactoryGirl.create(:course, candidate: candidate) }

  describe '#index' do
    before do
      FactoryGirl.create_list(:course, 10, candidate: candidate)
      login_as(user, :scope => :user)
      get "/api/v1/candidate/courses/", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "returns a list of all courses" do
      expect(json(response.body).length).to eq(10)
    end

  end

  describe '#show' do
    subject {create(:course, candidate: candidate) }

    before do
      login_as(user, :scope => :user)
      get "/api/v1/candidate/courses/#{subject.id}", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it "returns a valid course" do
      response_body = json(response.body)
      expect(response_body[:title]).to eql(subject.title)
    end
  end

  describe '#update' do
   subject {create(:course, candidate: candidate) }

   context 'when a valid record is submitted' do
      before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/courses/#{subject.id}", {is_visible: false, title:'test'}.to_json, json_content_type
      end

      it 'returns a succesful response' do
        expect(response).to be_success
      end

      it 'returns a record with the updated is_visible field' do
        response_body = json(response.body)
        expect(response_body[:is_visible]).to eql(false)
      end

      it 'returns a record with the original title field' do
        response_body = json(response.body)
        expect(response_body[:title]).to eql(subject.title)
      end
    end

    context 'when an invalid record is submitted' do
       before do
        login_as(user, :scope => :user)
        patch  "/api/v1/candidate/courses/#{subject.id+123}", {is_visible: true}.to_json, json_content_type
       end

       it 'returns a 404 response' do
        expect(response.status).to eq(404)
       end

     end

  end

end
