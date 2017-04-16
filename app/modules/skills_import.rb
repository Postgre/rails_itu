require 'csv'
module SkillsImport
  # Reads a file into a CSV table object on instantiation.
  # Instance method import_rows instantiates a RowImporter for each row in file
  class SkillsImporter
    def initialize(file)
      @log = Logger.new(STDOUT)
      @rows = CSV.read(file, headers: true)
      @log.info("Read file #{file}")
    end

    def import_rows
      @rows.each do |row|
        category_name = row['category_name']
        skill_name = row['skill_name']
        row_importer = RowImporter.new(category_name, skill_name)
        row_importer.import_row
      end
    end
  end

  # Creates category and/or skill defined in a row if not already existent.
  # Returns error if category is not defined for a row.
  class RowImporter
    def initialize(category_name, skill_name)
      @category_name = category_name
      @skill_name = skill_name
      @log = Logger.new(STDOUT)
      @results = { category: nil, skill: nil }
    end

    def import_row
      if @category_name.blank?
        @log.error("Missing category for #{@skill_name}. Skill not created!")
      else
        parent = SkillCategory.find_or_create_by!(name: @category_name)
        @results[:category] = parent
        @log.info("Category #{@category_name} found or created")
        unless @skill_name.blank?
          child = Skill.find_or_create_by!(name: @skill_name, skill_category_id: parent.id) do |s|
            s.skill_category_id = parent.id
          end
          @results[:skill] = child
          @log.info("Skill #{@skill_name} found or created")
        end
      end
    end

    def results
      @results
    end
  end
end
