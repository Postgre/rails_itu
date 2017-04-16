namespace :skills do
  desc 'Imports categories and skills from CSV file'
  task :import_skilldef, [:file] => [:environment] do |_t, args|
    require 'skills_import.rb'
    include SkillsImport
    log = Logger.new(STDOUT)

    file = args.file

    skills_importer = SkillsImport::SkillsImporter.new(file)
    skills_importer.import_rows
    log.info('Finished')
  end

  desc 'seed-fu generation'
  task :seed_fu => :environment do
    skillfile = File.open(Rails.root.join('db', 'fixtures', 'skills.rb'), "w")
    require 'csv'

    categories = []
    category = nil
    category_id = 0
    skill_id = 0


    SeedFu::Writer.write(skillfile, class_name: 'Skill', constraints: [:id]) do |writer|
      CSV.foreach(Rails.root.join('db', 'skills.csv')) do |row|
        if row[0] != category
          category = row[0]
          category_id += 1
          categories += [category]
        end
        skill_id += 1


        writer.add(id: skill_id,
                   skill_category_id: category_id,
                   name: row[1].rstrip.lstrip) if row[1]

      end
    end

    SeedFu::Writer.write(skillfile, class_name: 'SkillCategory', constraints: [:id]) do |writer|
      categories.each_with_index do |category, index|
        writer.add(id: index+1,
                   name: category)
      end
    end

    skillfile.close
  end
end
