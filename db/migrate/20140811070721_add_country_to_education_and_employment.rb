class AddCountryToEducationAndEmployment < ActiveRecord::Migration
  def change
    remove_column :education_records, :country
    remove_column :employment_records, :country

    add_column :education_records, :country_id, :integer
    add_column :employment_records, :country_id, :integer

    add_index :education_records, :country_id
    add_index :employment_records, :country_id
  end
end
