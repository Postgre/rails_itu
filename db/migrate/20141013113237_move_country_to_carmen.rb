class Country < ActiveRecord::Base

end

class MoveCountryToCarmen < ActiveRecord::Migration
  def change
    add_column :candidates, :country_iso3, :string
    add_column :companies, :country_iso3, :string
    add_column :education_records, :country_iso3, :string
    add_column :employment_records, :country_iso3, :string
    add_column :candidates, :region, :string
    add_column :companies, :region, :string
    add_column :education_records, :region, :string
    add_column :employment_records, :region, :string

    Candidate.reset_column_information
    Company.reset_column_information
    EducationRecord.reset_column_information
    EmploymentRecord.reset_column_information


    Candidate.no_touching do
      say_with_time 'moving country to iso3' do
        %w(Candidate Company EducationRecord EmploymentRecord).each do |model|
          say model
          model.classify.constantize.find_each do |item|
            item.update_attribute :country_iso3, Carmen::Country.named(Country.find(item.country_id).name).try(:alpha_3_code) if item.country_id
          end
        end
      end
    end
  end
end
