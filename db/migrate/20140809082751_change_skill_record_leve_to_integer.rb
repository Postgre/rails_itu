class ChangeSkillRecordLeveToInteger < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE skill_records")
    change_column :skill_records, :level, :integer, :default => 2
    add_index :skill_records, :level
  end
end
