module API
  module V1
    module Candidate
      class SkillRecordsController < ApiController
        def index
          skill_records = candidate.skill_records.includes(:skill)
          render json: skill_records, each_serializer: SkillRecordSerializer
        end

        def show
          render json: skill_record
        end

        def update
          if skill_record.update_attributes(skill_record_params)
            render json: skill_record
          else
            render json: error_response_wrapper(skill), status: :unprocessable_entity
          end
        end

        def create
          skill_record = candidate.skill_records.build(skill_record_params)
          if skill_record.save
            render json: candidate.skill_category_records, each_serializer: SkillCategoryRecordSerializer, scope: candidate
          else
            render json: error_response_wrapper(skill_record), status: :unprocessable_entity
          end
        end

        def reorder
          if skill_record.insert_at(params[:position])
            render json: skill_record.skill_category_record.skill_records.includes(:skill), each_serializer: SkillRecordSerializer
          else
            head :unprocessable_entity
          end
        end

        def featured
          skill_records = candidate.skill_records.featured
          render json: skill_records
        end

        def destroy
          skill_record.destroy
          head :no_content
        end

        def tree
          skill_category_records = candidate.skill_category_records
          render json: skill_category_records, each_serializer: SkillCategoryRecordSerializer, scope: candidate
        end

        private

          def skill_record
            @skill_record ||= candidate.skill_records.find(params[:id])
          end

          def candidate
            @candidate ||= current_user.candidate
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
