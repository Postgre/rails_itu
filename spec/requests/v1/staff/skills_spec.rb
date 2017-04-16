require 'rails_helper'

describe 'Skills' do
  let(:candidate) { create :candidate, :john }
  let(:another_candidate) { create :candidate }
  let(:staff) { create :user, :staff }
  let(:skill) { candidate.skill_records.first.skill }
  let(:new_skill) { create :skill }

  context 'with staff user' do
    context 'delete skill' do
      before do
        login_as(staff, :scope => :user)
        delete "/api/v1/staff/skills/#{skill.id}", {}, json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'deletes given skill' do
        expect(candidate.skill_records.size).to eql(0)
      end
    end

    context 'add skill' do
      before do
        create(:skill_record, skillable: another_candidate, skill: skill)
        login_as(staff, :scope => :user)
        put "/api/v1/staff/skills/#{skill.id}/add-skill", {skill_id: new_skill.id}.to_json, json_content_type
      end

      it 'returns 200 status code' do
        expect(response.status).to eql(200)
      end

      it 'adds given skill' do
        expect(candidate.skill_records.map(&:skill_id)).to include(new_skill.id)
        expect(another_candidate.skill_records.map(&:skill_id)).to include(new_skill.id)
      end
    end
  end
end