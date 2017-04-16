require 'rails_helper'

describe Interview do
  context "validations" do
    let(:interview) { build(:interview, :in_itu) }

    it "requires a company" do
      interview.company = nil
      expect(interview.valid?).to be_falsey
    end

    it { should validate_presence_of(:job_id) }

    it "requires a candidate" do
      interview.candidate = nil
      expect(interview.valid?).to be_falsey
    end

    it "requires a date" do
      interview.date = nil
      expect(interview.valid?).to be_falsey
    end

    it "requires a location" do
      interview.location = nil
      expect(interview.valid?).to be_falsey
    end

    it "requires a valid date" do
      interview.date = nil
      expect(interview.valid?).to be_falsey
    end

    it "requires a valid suggested_date" do
      interview.suggested_date = 1.day.ago
      expect(interview.valid?).to be_falsey
    end
  end
end
