class AddVerifiedAndGraduatedToEducationRecords < ActiveRecord::Migration
  def change
    add_column :education_records, :verified, :boolean
    add_column :education_records, :graduated, :boolean
  end
end
