module API
  module V1
    module Candidate
      class CandidatesController < ApiController
        def show
          authorize candidate, :show?
          scope = params[:company_id] ? ::Company.find(params[:company_id]) : current_user
          render json: candidate, serializer: CandidateSerializer, scope: scope
        end

        def update
          authorize candidate, :update?
          if candidate.update_attributes(candidate_params)
            render json: candidate, serializer: CandidateSerializer
          else
            render json:  candidate.errors, status: :unprocessable_entity
          end
        end

        def recommended
          authorize candidate, :show?
          render json: candidate.recommended, each_serializer: JobSerializer, scope: candidate.user
        end

        protected

        def candidate
          @candidate ||= current_user.candidate
        end

        def candidate_params
          list = %w(about availability city country_iso3 region)
          list += ['is_visible'] unless candidate.is_visible_locked
          list.map!(&:to_sym)
          params.permit(list)
        end
      end
    end
  end
end
