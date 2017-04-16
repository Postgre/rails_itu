class AddDefaultValueToVerifiedAndGraduated < ActiveRecord::Migration
  def change
    change_column :education_records, :verified, :boolean, :default => false
    change_column :education_records, :graduated, :boolean, :default => false
  end
end
