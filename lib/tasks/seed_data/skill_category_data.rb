module SeedData
  class SkillCategoryData
    class << self
      def categorized_skills
        Rake::Task['import_skilldef'].invoke("lib/tasks/seed_data/Skills.csv")
      end

      def load
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE skill_categories")
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE skills")
        categorized_skills
        # ::SkillCategory.create(categorized_skills)
        nil
      end
    end
  end
end
