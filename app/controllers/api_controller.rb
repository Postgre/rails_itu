class ApiController < ApplicationController
  # include ActionController::MimeResponds
  # include ActionController::Cookies
  # include ActionController::ForceSSL
  # include ApplicationExceptionHandler
  # include ActionController::HttpAuthentication::Token::ControllerMethods
  # include ErrorResponseFormat
  # include Pundit

  before_action :authenticate_user!

  unless Rails.env.development?
    rescue_from Exception, with: :server_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::MethodNotAllowed, with: :method_not_allowed
    rescue_from Pundit::NotAuthorizedError, with: :permission_denied
  end

  protected

  def permission_denied
    head :forbidden
  end

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
    unless App.find_app(params[:id]).present?
      render json: { message: 'The requested App was not found' }, status: :not_found
    end
  end

  def set_pagination_limit
    @limit = params[:limit] || 10
    @page = params[:page] || 1
 end

  #
  # def authenticate
  #   authenticate_token || render_unauthorized
  # end
  #
  # def current_user
  #   @current_user
  # end
  #
  # def authenticate_token
  #   authenticate_with_http_token do |token, options|
  #     itu_id = Rails::Redis.hget(token, 'itu_id')
  #     Rails.logger.debug "Redis: get #{token}:itu_id = #{itu_id}"
  #     @current_user ||= User.find_by(itu_id: itu_id)
  #   end
  # end
  #
  # def render_unauthorized
  #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  #   render json: {errors: ['Invalid Access Token']}, status: :unauthorized
  # end
end
