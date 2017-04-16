module API
  module V1
    module Candidate
      class JobsController < ApiController
        def recommended
          if !current_user.candidate or current_user.candidate.skills.empty?
            render json: []
          else
            @jobs = ::Job.visible.recommended_for_candidate(current_user.candidate)
            prepare_job_list!

            render json: @jobs, each_serializer: CandidateJobSerializer, scope: current_user
          end
        end

        def index
          if !current_user.candidate
            render json: []
          else
            @jobs = ::Job.visible.orderable_by_skill_match(current_user.candidate)
            prepare_job_list!

            render json: @jobs, each_serializer: CandidateJobSerializer, scope: current_user
          end
        end

        def show
          @job = Job.find(params[:id])

          authorize @job, :show?
          render json: @job, serializer: CandidateJobSerializer, scope: current_user
        end

        def favorite
          if current_user.candidate
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: job.id, subject_type: 'Job').first_or_create

            head :ok
          else
            head :not_found
          end
        end

        def unfavorite
          if current_user.candidate
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: job.id, subject_type: 'Job').destroy_all

            head :ok
          else
            head :not_found
          end
        end

        private
          def sort_column
            (::Job.column_names + ['jobs.last_state_change_at', 'unmatched_skill_count']).include?(params[:order]) ? params[:order] : "jobs.id"
          end

          def prepare_job_list!
            return if @jobs == []
            @jobs = @jobs.starred_by_candidate(current_user.candidate) if params[:is_favorited] == "true"
            @jobs = @jobs.joins(:job_applications) if params[:has_applied] == "true"
            @jobs = @jobs.search(params[:q] ? JSON.parse(params[:q]) : nil).result
            @jobs = @jobs.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, jobs.id") if params[:order]
            @jobs = @jobs.page(params[:page])

            response.headers['X-total']  = @jobs.total_count.to_s
            response.headers['X-offset']  = @jobs.offset_value.to_s
            response.headers['X-limit']  = @jobs.limit_value.to_s
          end

          def job
            @job ||= Job.find(params[:id])
          end
      end
    end
  end
end
