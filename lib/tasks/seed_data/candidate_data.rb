module SeedData
  class CandidateData
    class << self
      def create(user)
        user   = SeedData::UserData.candidate
        c      = ::Candidate.new
        c.user = user
        c.save
        c
      end

      def employment_records(candidate, limit = Random.rand(4) + 1)
        SeedData::EmploymentRecordData.create(candidate, limit)
      end

      def education_records(candidate, limit = Random.rand(2) + 1)
        SeedData::EducationRecordData.create(candidate, limit)
      end

      def skill_records(candidate, limit = Random.rand(2) + 1)
        SeedData::SkillRecordData.create(candidate, limit)
      end

      def skill_category_records(candidate, limit = Random.rand(2) + 1)
        SeedData::SkillCategoryRecordData.create(candidate, limit)
      end

      def finalized_candidate_profiles(limit=20)
        limit.times do
          user      = SeedData::UserData.candidate
          candidate = SeedData::CandidateData.create(user)
          employment_records(candidate)
          education_records(candidate)
          skill_records(candidate)
          skill_category_records(candidate)
        end
      end
    end
  end
end
