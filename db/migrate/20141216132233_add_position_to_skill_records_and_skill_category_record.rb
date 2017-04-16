class AddPositionToSkillRecordsAndSkillCategoryRecord < ActiveRecord::Migration
  def change
    add_column :skill_records, :position, :integer
    add_column :skill_records, :skill_category_record_id, :integer
    add_column :skill_category_records, :position, :integer
    add_index :skill_records, :position
    add_index :skill_category_records, :position
  end
end
