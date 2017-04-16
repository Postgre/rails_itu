class CandidateCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_url, :state, :website, :company_size,
             :industry_id, :country_iso3, :city, :street_address, :street_address2,
             :phone_number, :postal_code, :about_us, :region, :is_favorited

  has_one :industry

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end

  def logo_url
    object.logo.url
  end

  def is_favorited
    return false unless scope.candidate
    scope.candidate.favorites.where(subject_id: object.id).any?
  end
end
