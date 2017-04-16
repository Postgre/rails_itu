class API::V1::AvailabilityOptionsController < ApiController
  def index
    render json: Candidate::AVAILABILITY_OPTIONS.to_json
  end
end
