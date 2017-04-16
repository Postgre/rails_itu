class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      redirect_to current_user.main_app_route
    else
      render layout: 'index'
    end
  end

  def company_sign_up
  end
end
