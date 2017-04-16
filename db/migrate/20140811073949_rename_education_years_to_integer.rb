class RenameEducationYearsToInteger < ActiveRecord::Migration
  def change
    change_column :education_records, :start_year, :integer
    change_column :education_records, :end_year, :integer
  end
end
