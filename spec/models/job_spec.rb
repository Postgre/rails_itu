require 'rails_helper'

describe Job do
  subject { FactoryGirl.build(:job) }

  it { should be_valid }
  it { should belong_to(:company) }
  it { should have_many(:skill_records) }

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:company_id) }
    it { should validate_presence_of(:work_type) }
    it { should validate_presence_of(:schedule) }
  end

  context '.starred_by_candidate' do
    let(:candidate) { FactoryGirl.create :candidate }
    let(:job) { FactoryGirl.create :job }

    context "when there aren't starred jobs" do
      it "brings an empty list" do
        expect(Job.starred_by_candidate(candidate)).to be_empty
      end
    end

    context "when there are starred jobs" do
      before :each do
        candidate.favorites.create(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job')
      end

      it "brings a list with starred jobs" do
        expect(Job.starred_by_candidate(candidate)).to_not be_empty
      end
    end

    context "when there are recommended and starred jobs" do
      let(:staff_user) {FactoryGirl.create(:user, :staff)}

      before :each do
        candidate.favorites.create(creator_id: staff_user.id, subject_id: job.id, subject_type: 'Job')
        candidate.favorites.create(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job')
      end

      it "brings a list with recommended jobs only" do
        expect(Job.starred_by_candidate(candidate).size).to eq(1)
      end
    end
  end

  context '.recommended' do
    pending
  end

  context '.orderable_by_skill_match' do
    pending
  end

  context '.matched_for_candidate' do
    let(:candidate) { FactoryGirl.create :candidate }
    let(:job) { FactoryGirl.create :job }

    context "when there aren't any skills to match jobs and candidates" do
      it "brings an empty list" do
        expect(Job.matched_for_candidate(candidate)).to be_empty
      end
    end

    context "when there's a skill match" do
      # before :each do
      #   Rails::Redis.del("Candidate:#{candidate.id}:skills")
      #   @candidate_skill_record = FactoryGirl.create(:skill_record, :candidate_skill_record, skillable: candidate)
      #   FactoryGirl.create(:skill_record, :job_skill_record, skillable: job, skill: @candidate_skill_record.skill)
      # end

      pending

      # it "brings an non-empty list"do
      #   pending
      # end
    end
  end


  context '.staff_recommended_for_candidate' do
    let(:candidate) { FactoryGirl.create :candidate }
    let(:job) { FactoryGirl.create :job }

    context "when there aren't recommended jobs" do
      it "brings an empty list" do
        expect(Job.staff_recommended_for_candidate(candidate)).to be_empty
      end
    end

    context "when there are starred jobs" do
      before :each do
        candidate.favorites.create(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job')
      end

      it "brings an empty list" do
        expect(Job.staff_recommended_for_candidate(candidate)).to be_empty
      end
    end

    context "when there are recommended jobs" do
      let(:staff_user) {FactoryGirl.create(:user, :staff)}

      before :each do
        candidate.favorites.create(creator_id: staff_user.id, subject_id: job.id, subject_type: 'Job')
      end

      it "brings a list with recommended jobs" do
        expect(Job.staff_recommended_for_candidate(candidate)).to_not be_empty
      end
    end

    context "when there are recommended and starred jobs" do
      let(:staff_user) {FactoryGirl.create(:user, :staff)}

      before :each do
        candidate.favorites.create(creator_id: staff_user.id, subject_id: job.id, subject_type: 'Job')
        candidate.favorites.create(creator_id: candidate.user.id, subject_id: job.id, subject_type: 'Job')
      end

      it "brings a list with recommended jobs only" do
        expect(Job.staff_recommended_for_candidate(candidate).size).to eq(1)
      end
    end
  end

  context '.recommended_for_candidate' do
    pending
  end


end
