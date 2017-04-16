module API
  module V1
    module Staff
      class JobsController < ApiController
        before_action :find_job, only: [:show, :recommend, :unrecommend, :flag, :recommended, :applications]
        before_action :find_user, only: [:recommend, :unrecommend]

        def index
          authorize :job, :index?

          if params[:q]
            q = JSON.parse(params[:q])
            with_interviews = q.delete('with_interviews')
          else
            q = nil
          end

          @jobs = ::Job.includes(:company, :skill_records, :skills).search(q).result.uniq
          @jobs = @jobs.with_interviews(with_interviews == 'true') if with_interviews.in? %w(true false)
          @jobs = @jobs.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, jobs.id") if params[:order]

          @jobs = @jobs.page(params[:page])
          response.headers['X-total']   = @jobs.total_count.to_s
          response.headers['X-offset']  = @jobs.offset_value.to_s
          response.headers['X-limit']   = @jobs.limit_value.to_s

          render json: @jobs, each_serializer: StaffJobSerializer
        end

        def show
          authorize @job, :show?

          render json: @job, serializer: StaffJobSerializer
        end

        def recommended
          render json: @job.recommended, each_serializer: CandidateSerializer, scope: @job
        end

        def applications
          render json: @job.job_applications, each_serializer: JobApplicationSerializer, scope: @job
        end

        def flag
          authorize @job, :flag?

          if @job.flag
            head :ok
          else
            render json: {errors: @job.errors}, status: :unprocessable_entity
          end
        end

        def recommend
          authorize :job, :recommend?

          if @user.candidate
            if @job.is_public && @job.published?
              @user.candidate.favorites.where(creator_id: current_user.id, subject_id: @job.id, subject_type: 'Job').first_or_create

              head :ok
            else
              render json: {errors: I18n.t('errors.messages.job.non_public')}, status: :unprocessable_entity
            end
          else
            head :not_found
          end
        end

        def unrecommend
          authorize :job, :recommend?

          if @user.candidate
            @user.candidate.favorites.where(subject_id: @job.id, subject_type: 'Job').where.not(creator_id: @user.id).destroy_all

            head :ok
          else
            head :not_found
          end
        end

        private

          def find_user
            @user = User.find(params[:user_id])
          end

          def find_job
            @job = ::Job.find(params[:id])
          end

          def sort_column
            (::Job.column_names).include?(params[:order]) ? params[:order] : 'jobs.id'
          end
      end
    end
  end
end
