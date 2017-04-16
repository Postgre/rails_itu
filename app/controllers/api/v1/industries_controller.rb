module API
  module V1
    class IndustriesController < ApiController
      skip_before_action :authenticate, only: [:index]
      def index
        render json: Industry.order(:name).all
      end
    end
  end
end
