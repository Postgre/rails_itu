module API
  module V1
    module Staff
      class CandidatesController < ApiController
        before_action :find_candidate, only: [:show]

        def index
          authorize :candidate, :index?

          @serializer = StaffCandidateSerializer
          @serializer = StaffLightCandidateSerializer if params[:lightweight]

          @candidates = ::Candidate.joins(:user).includes(:skill_records, :skills, :user)
          @candidates = @candidates.search(params[:q] ? JSON.parse(params[:q]) : nil).result
          @candidates = @candidates.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, candidates.id") if params[:order]
          @candidates = @candidates.page(params[:page])
          response.headers['X-total']   = @candidates.total_count.to_s
          response.headers['X-offset']  = @candidates.offset_value.to_s
          response.headers['X-limit']   = @candidates.limit_value.to_s
          render json: @candidates, each_serializer: @serializer
        end

        def show
          authorize @candidate, :show?
          render json: @candidate, serializer: StaffCandidateSerializer
        end

        private

          def find_candidate
            @candidate = ::Candidate.find(params[:id])
          end

          def sort_column
            (::Candidate.column_names + ['users.email', 'users.first_name', 'users.last_name']).include?(params[:order]) ? params[:order] : "users.email"
          end
      end
    end
  end
end
