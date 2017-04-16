module API
  module V1
    module Company
      class JobApplicationsController < ApiController
        before_action :find_job!

        def index
          authorize @company, :manage?

          render json: @job.applications, each_serializer: JobApplicationSerializer
        end

        def show
          authorize job_application, :show?

          render json: job_application, serializer: JobApplicationSerializer
        end

        def reject
          authorize job_application, :interact?
          if job_application.reject
            head :ok
          else
            render json: job_application.errors, status: :unprocessable_entity
          end
        end

        def transition
          authorize job_application, :interact?
          events = *policy(job_application).permitted_events
          if events.include?(params[:event].to_sym)
            if job_application.fire_state_event(params[:event].to_sym)
              job_application.update_attribute :changer_id, current_user.id
              render json: job_application, serializer: JobApplicationSerializer
            else
              render json: job_application.errors, status: :unprocessable_entity
            end
          else
            head :unprocessable_entity
          end
        end

        private
          def find_job!
            @company = ::Company.find(params[:company_id])
            @job = @company.jobs.find(params[:job_id])
          end

          def job_application
            @job_application ||= @job.job_applications.find(params[:id])
          end
      end
    end
  end
end
