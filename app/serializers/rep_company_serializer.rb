class RepCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_url, :state, :website, :company_size,
             :industry_id, :country_iso3, :country, :city, :street_address, :street_address2,
             :phone_number, :postal_code, :about_us, :region

  has_one :industry
  has_many :users, serializer: RepUserSerializer

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end

  def logo_url
    object.logo.url
  end
end
