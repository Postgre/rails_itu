class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  before_action :authenticate_user!

  protect_from_forgery with: :exception

  respond_to :html, :json

  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected
    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end

    def current_admin_user
      return unless session[:current_admin_user_id]
      @current_admin_user ||= User.find(session[:current_admin_user_id])
    end
    helper_method :current_admin_user

    def current_admin_user?
      current_admin_user.present?
    end
    helper_method :current_admin_user?
end
