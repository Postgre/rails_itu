require 'rails_helper'

describe 'SkillCategory' do

  let(:user) { FactoryGirl.create :user, :john }
  subject { create(:skill_category) }

  describe '#index' do
    before do
      login_as(user, :scope => :user)
      SkillCategory.stub(:all).and_return([FactoryGirl.attributes_for(:skill_category)])
      get '/api/v1/skill-categories', {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'returns a list of skill categories' do
      response_body = json(response.body)
      expect(response_body.size).to eq(1)
    end
  end

  describe '#show' do
    before do
      login_as(user, :scope => :user)
      get "/api/v1/skill-categories/#{subject.id}", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'returns a skill category record' do
      response_body = json(response.body)
      expect(response_body[:name]).to eq(subject[:name])
    end
  end

  describe '#skills' do
    before do
      allow(subject).to receive(:skills).and_return([create(:skill, skill_category: subject)])
      login_as(user, :scope => :user)
      get "/api/v1/skill-categories/#{subject.id}/skills", {}, json_content_type
    end

    it 'returns a successful response' do
      expect(response).to be_success
    end

    it 'returns a list of category skills' do
      response_body = json(response.body)
      expect(response_body.size).to eql(1)
    end
  end

end
