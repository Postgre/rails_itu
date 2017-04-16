module API
  module V1
    module Company
      class InterviewsController < ApiController
        before_action :find_job!

        def index
          authorize @company, :manage?

          render json: @job.interviews, each_serializer: InterviewSerializer
        end

        def show
          authorize interview, :show?

          render json: interview, serializer: InterviewSerializer
        end

        def create
          authorize @company, :manage?

          interview = @job.interviews.build(interview_params)
          if interview.save
            @job.job_applications.where(candidate_id: interview.candidate_id, state: 'created').each(&:accept)
            render json: interview, serializer: InterviewSerializer
          else
            render json: interview.errors, status: :unprocessable_entity
          end
        end

        def update
          authorize interview, :manage?

          if interview.update_attributes(interview_params)
            render json: interview, serializer: InterviewSerializer
          else
            render json: interview.errors, status: :unprocessable_entity
          end
        end

        def transition
          authorize interview, :interact?
          events = *policy(interview).permitted_events
          if events.include?(params[:event].to_sym)
            if interview.fire_state_event(params[:event].to_sym)
              interview.update_attribute :changer_id, current_user.id
              render json: interview, serializer: InterviewSerializer
            else
              render json: interview.errors, status: :unprocessable_entity
            end
          else
            head :unprocessable_entity
          end
        end

        private
          def interview_params
            params.require(:interview).permit(:company_id, :candidate_id, :date, :location, :details, :notes)
          end

          def find_job!
            @company = ::Company.find(params[:company_id])
            @job = @company.jobs.find(params[:job_id])
          end

          def interview
            @interview ||= @job.interviews.find(params[:id])
          end
      end
    end
  end
end
