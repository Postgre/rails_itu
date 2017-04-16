module API
  module V1
    class GeocodersController < ApiController
      def show
        render json: Geocoder.search(params[:q]).map(&:data)
      end
    end
  end
end
