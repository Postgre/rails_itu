class AddCountryIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :country_id, :integer
  end
end
