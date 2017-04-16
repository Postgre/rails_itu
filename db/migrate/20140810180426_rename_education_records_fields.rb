class RenameEducationRecordsFields < ActiveRecord::Migration
  def change
    rename_column :education_records, :graduated, :has_graduated
    rename_column :education_records, :verified, :is_verified
  end
end
