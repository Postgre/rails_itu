module API
  module V1
    class CountriesController < ApiController
      skip_before_action :authenticate, only: [:index]
      def index
        countries = Carmen::Country.all
        countries = countries.select {|c| c.include? params[:q] } if params[:q]
        render json: countries.sort_by{|c| c.name}.map{|c| [c.alpha_3_code, c.name]}
      end
    end
  end
end
