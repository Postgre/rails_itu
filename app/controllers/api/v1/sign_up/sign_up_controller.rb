module API
  module V1
    module SignUp
      class SignUpController < ApiController
        # skip_before_action :authenticate, only: [:company_sign_up]
        # skip_before_filter :require_logged_user


        def company_sign_up
          @company = ::Company.new(company_params)
          if @company.save
            @company.send_email(@company.status)
            render json: @company, status: :created
          else
            render json: @company.errors, status: :unprocessable_entity
          end
        end

        private

        def company_params
          parameters = [
              :success,
              :name,
              :website,
              :about_us,
              :skype_username,
              users_attributes: [
                  :email,
                  :password,
                  :password_confirmation,
                  :first_name,
                  :last_name,
                  :middle_name
              ]
          ]
          params.require(:company).permit(parameters)
        end
      end
    end
 end
end
