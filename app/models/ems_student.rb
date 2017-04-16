class EmsStudent < ActiveResource::Base
  self.site = Rails.application.config.ems_base_url
  self.element_name = 'student'
  add_response_method :http_response

  has_one :user, class_name: 'ems_user'
  has_many :degree_histories, class_name: 'ems_degree_history'
  has_many :courseterm_students, class_name: 'ems_course'

  def self.headers
    { 'Authorization' => "Token token=#{ENV['EMS_TOKEN']}"}
  end
end
