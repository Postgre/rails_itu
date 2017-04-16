module API
  module V1
    module Company
      class SkillRecordsController < ApiController
        before_action :find_job
        before_action :find_skill_record, only: [:show, :update, :destroy, :reorder]

        def index
          render json: @job.skill_records.includes(:skill), each_serializer: SkillRecordSerializer
        end

        def show
          render json: @skill_record
        end

        def update
          if @skill_record.update_attributes(skill_record_params)
            render json: @skill_record
          else
            render json: @skill_record.errors, status: :unprocessable_entity
          end
        end

        def create
          skill_record = @job.skill_records.build(skill_record_params)
          if skill_record.save
            render json: @job.skill_category_records, each_serializer: SkillCategoryRecordSerializer, scope: @job
          else
            render json: skill_record.errors, status: :unprocessable_entity
          end
        end

        def destroy
          @skill_record.destroy
          head :no_content
        end

        def reorder
          if @skill_record.insert_at(params[:position])
            render json: @skill_record.skill_category_record.skill_records.includes(:skill), each_serializer: SkillRecordSerializer
          else
            head :unprocessable_entity
          end
        end

        private

          def find_skill_record
            @skill_record = @job.skill_records.find(params[:id])
          end

          def find_job
            @job = Job.find(params[:job_id])
            authorize @job, :manage?
          end

          def skill_record_params
            allowed_params = [
              :level,
              :is_featured,
              :years_of_experience,
              :skill_id
            ]
            params.permit(allowed_params)
          end
      end
    end
  end
end
