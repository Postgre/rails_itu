module API
  module V1
    class JobsController < ApiController
      before_action :find_job, only: [:show]

      def index
        @jobs = Job.visible
        @jobs = @jobs.page(params[:page])
        response.headers['X-total']  = @jobs.total_count.to_s
        response.headers['X-offset']  = @jobs.offset_value.to_s
        response.headers['X-limit']  = @jobs.limit_value.to_s
        render json: @jobs, each_serializer: JobSerializer
      end

      def show
        authorize @job, :show?
        scope = current_user
        scope = Job.find(params[:job_id]) if params[:job_id]
        render json: @job, serializer: JobSerializer, scope: scope
      end

      private

        def find_job
          @job = ::Job.find(params[:id])
        end
    end
  end
end


