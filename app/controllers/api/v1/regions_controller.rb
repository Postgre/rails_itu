module API
  module V1
    class RegionsController < ApiController
      skip_before_action :authenticate, only: [:index]
      def index
        render json: Carmen::Country.coded(params[:country_id]).subregions.map{|c| {code: c.code, name: c.name}}
      end
    end
  end
end
