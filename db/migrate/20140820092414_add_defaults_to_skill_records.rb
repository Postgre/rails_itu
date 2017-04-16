class AddDefaultsToSkillRecords < ActiveRecord::Migration
  def change
    SkillRecord.where(level: nil).update_all(level: 2)
    change_column :skill_records, :level, :integer, null: false
    SkillRecord.where(years_of_experience: nil).update_all(years_of_experience: 1)
    change_column :skill_records, :years_of_experience, :integer, null: false, default: 1
    SkillRecord.where(is_featured: nil).update_all(is_featured: false)
    change_column :skill_records, :is_featured, :boolean, null: false, default: false
  end
end
