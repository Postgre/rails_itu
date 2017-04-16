class ItuIdUser < ActiveResource::Base
  self.site = Rails.application.config.id_base_url
  self.element_name = 'user'

  def self.headers
    {'Authorization' => "Token token=#{ENV['ID_TOKEN']}"}
  end
end
