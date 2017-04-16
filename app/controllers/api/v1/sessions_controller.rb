module API
  module V1
    class SessionsController < ApiController
      def destroy
        if current_admin_user?
          @admin = current_admin_user
          sign_in(@admin)
          session[:current_admin_user_id] = nil
          render json: current_user, serializer: CurrentUserSerializer
        else
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          head :ok
        end
      end
    end
  end
end