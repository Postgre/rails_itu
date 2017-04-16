class EmsDegreeHistory < ActiveResource::Base
  self.site = Rails.application.config.ems_base_url
  self.element_name = 'degree_history'
  add_response_method :http_response
end
