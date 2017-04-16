class EmploymentRecordSerializer < ActiveModel::Serializer
  attributes :id, :company_name, :city, :start_date, :end_date, :is_current_job, :description, :job_title,
             :country, :country_iso3, :region

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end
end
