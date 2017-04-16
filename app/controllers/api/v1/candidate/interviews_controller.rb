module API
  module V1
    module Candidate
      class InterviewsController < ApiController
        def index
          render json: current_user.try(:candidate).try(:interviews), each_serializer: CandidateInterviewSerializer
        end

        def show
          render json: current_user.try(:candidate).try(:interviews).try(:find, params[:id]), serializer: CandidateInterviewSerializer
        end
      end
    end
  end
end
