class BasePublicController < ActionController::Base
  include Swagger::Docs::ImpotentMethods
  after_action :set_access_control_headers
  before_action :set_pagination_limit, only: [ :index ]
  before_action :validate_app

  unless Rails.env.development?
    rescue_from Exception, with: :server_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::MethodNotAllowed, with: :method_not_allowed
  end

  protected

  def server_error(exception)
    Rails.logger.error(exception)
    render json: { message: 'Internal server error' }, status: :internal_server_error
  end

  def record_not_found
    render json: { message: 'The requested resource was not found' }, status: :not_found
  end

  def method_not_allowed
    render json: { error: 'method not allowed' }, status: :method_not_allowed
  end

  def validate_app
    unless App.find_app(params[:app_id]).present?
      render json: { message: 'The requested App was not found' }, status: :not_found
    end
  end

  def set_pagination_limit
    @limit = params[:limit] || 10
    @page  = params[:page] || 1
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
