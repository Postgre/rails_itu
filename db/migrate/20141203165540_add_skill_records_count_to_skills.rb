class AddSkillRecordsCountToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :skill_records_count, :integer, default: 0, null: false

    say_with_time 'update counters' do
      Skill.find_each do |skill|
        Skill.reset_counters(skill.id, :skill_records)
      end
    end
  end
end
