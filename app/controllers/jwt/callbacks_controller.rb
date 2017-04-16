class Jwt::CallbacksController < ApplicationController
  # Skips the CSRF protection for the jwt action so that the session is retained
  # and the user_return_to value can be used to redirect the user back to the
  # page they originally requested after login.
  protect_from_forgery except: :jwt
  skip_before_action :authenticate_user!

  def jwt
    jwt = JWT.decode(params['jwt'].to_s, ENV.fetch('JWT_SECRET'))[0]

    #further validation of claims adapted from https://rapid.test.aaf.edu.au/
    token_valid = (jwt['iss'] == Rails.application.config.id_url &&
      jwt['aud'] ==  Rails.application.config.bridge_url)
    token_valid = token_valid && Time.now > Time.at(jwt['nbf']) if jwt.keys.include?('nbf')
    token_valid = token_valid && Time.now < Time.at(jwt['exp']) if jwt.keys.include?('exp')

    if token_valid
      itu_id = Rails::Redis.hget(jwt['token'], 'itu_id')
      Rails.logger.debug "Redis: get #{jwt['token']}:itu_id = #{itu_id}"
      @user = User.find_by(itu_id: itu_id)

      if @user
        sign_in @user
        Rails.logger.debug "Redirecting to #{@user.main_app_route}"
        redirect_to @user.main_app_route
      else
        redirect_to Rails.application.config.id_url, error: 'Invalid User'
      end
    else
      redirect_to Rails.application.config.id_url, error: 'Invalid Access Token'
    end
  end
end