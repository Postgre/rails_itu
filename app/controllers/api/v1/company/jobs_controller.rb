module API
  module V1
    module Company
      class JobsController < ApiController
        before_action :find_company!

        def index
          jobs = JobPolicy::Scope.new(current_user, @company.jobs, @company).resolve
          if params[:q]
            with_interviews = q.delete('with_interviews')
            q = JSON.parse(params[:q])
          else
            q = nil
          end

          jobs = jobs.search(q).result
          jobs = jobs.with_interviews(with_interviews == 'true') if with_interviews.in? %w(true false)
          jobs = jobs.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, jobs.id") if params[:order]
          jobs = jobs.page(params[:page])
          response.headers['X-total']   = jobs.total_count.to_s
          response.headers['X-offset']  = jobs.offset_value.to_s
          response.headers['X-limit']   = jobs.limit_value.to_s

          render json: jobs, each_serializer: serializer
        end

        def show
          authorize job, :show?

          render json: job, serializer: serializer
        end

        def create
          authorize @company, :manage?

          job = @company.jobs.build(job_params)
          if job.save
            job.publish if params[:publish]
            render json: job, status: :created, serializer: JobSerializer
          else
            render json: job.errors, status: :unprocessable_entity
          end
        end

        def update
          authorize @company, :manage?

          if job.update_attributes(job_params)
            render json: job, serializer: JobSerializer
          else
            render json: job.errors, status: :unprocessable_entity
          end
        end

        def favorite
          if current_user.candidate
            authorize job, show?
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: job.id, subject_type: 'Job').first_or_create

            head :ok
          else
            head :not_found
          end
        end

        def unfavorite
          if current_user.candidate
            authorize job, show?
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: job.id, subject_type: 'Job').destroy_all

            head :ok
          else
            head :not_found
          end
        end

        def transition
          authorize job, :action?

          if Job.state_machine.events.map(&:name).include?(params[:event].to_sym)
            if job.fire_state_event(params[:event].to_sym)
              render json: job, serializer: JobSerializer
            else
              render json: job.errors, status: :unprocessable_entity
            end
          else
            head :unprocessable_entity
          end
        end

        def recommended
          authorize job, :manage?
          render json: job.recommended, each_serializer: CandidateSerializer, scope: @job
        end

        def applications
          authorize job, :manage?
          render json: job.job_applications, each_serializer: JobApplicationSerializer, scope: @job
        end

        private
          def serializer
            if current_user.has_role?(:representative, @company)
              JobSerializer
            else
              CandidateJobSerializer
            end
          end

          def find_company!
            @company = ::Company.find(params[:company_id])
          end

          def job
            @job ||= @company.jobs.find(params[:id])
          end

          def job_params
            params.require(:job).permit(:title,
                                        :description,
                                        :company_id,
                                        :work_type,
                                        :start_date,
                                        :schedule,
                                        :is_public,
                                        :location,
                                        skill_records_attributes: [
                                            :level,
                                            :is_featured,
                                            :years_of_experience,
                                            :skill_id
                                        ])
          end

          def sort_column
            (Job.column_names).include?(params[:order]) ? 'jobs.' + params[:order] : 'jobs.id'
          end

      end
    end
  end
end
