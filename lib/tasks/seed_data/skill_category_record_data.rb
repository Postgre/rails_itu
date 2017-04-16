module SeedData
  class SkillCategoryRecordData
    class << self      
      def create(candidate, limit=4)
        num_skill_cat_available = ::SkillCategory.count
        limit.times do
          sk                     = ::SkillCategoryRecord.new
          sk.skill_categorizable = candidate
          sk.skill_category      = SkillCategory.limit(num_skill_cat_available).sample
          sk.save
        end
      end
    end
  end
end
