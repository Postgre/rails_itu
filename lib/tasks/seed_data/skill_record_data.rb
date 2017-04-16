module SeedData
  class SkillRecordData
    class << self
      def create(candidate, limit=4)
        number_of_skills_available = ::Skill.count
        limit.times do
          sk           = ::SkillRecord.new
          sk.skillable = candidate
          sk.level     = [0, 1, 2,3].sample
          sk.years_of_experience = rand(19) + 1
          sk.skill = Skill.limit(number_of_skills_available).sample
          sk.save
        end
      end
    end
  end
end
