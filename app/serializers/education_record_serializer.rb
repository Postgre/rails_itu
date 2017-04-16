class EducationRecordSerializer < ActiveModel::Serializer
  attributes :id, :school, :city, :start_year, :end_year, :degree, :country, :country_iso3, :region, :field_of_study

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end

end
