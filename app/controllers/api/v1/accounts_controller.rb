module API
  module V1
    class AccountsController < ApiController
      def show
        render json: current_user, serializer: CurrentUserSerializer
      end
    end
  end
end
