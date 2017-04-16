module API
  module V1
    module Candidate
      class JobApplicationsController < ApiController
        before_action :find_job!

        def show
          authorize job_application, :show?

          render json: job_application, serializer: JobApplicationSerializer
        end

        def create
          authorize @job, :apply?

          job_application = @job.job_applications.where(candidate_id: current_user.candidate.id).build(job_application_params)
          if job_application.save
            render json: job_application, serializer: JobApplicationSerializer
          else
            render json: job_application.errors, status: :unprocessable_entity
          end
        end

        def update
          authorize job_application, :manage?

          if job_application.update_attributes(job_application_params)
            render json: job_application, serializer: JobApplicationSerializer
          else
            render json: job_application.errors, status: :unprocessable_entity
          end
        end

        private
          def job_application_params
            params.permit(:cover_letter, :resume)
          end

          def find_job!
            @job = Job.find(params[:job_id])
          end

          def job_application
            @job_application ||= @job.job_applications.find(params[:id])
          end
      end
    end
  end
end
