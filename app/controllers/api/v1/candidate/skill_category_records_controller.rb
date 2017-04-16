module API
  module V1
    module Candidate
      class SkillCategoryRecordsController < ApiController
        def index
          skill_category_records = candidate.skill_category_records
          render json: skill_category_records, each_serializer: SkillCategoryRecordSerializer, scope: candidate
        end

        def show
        	render json: skill_category_record
        end

        def update
        	if skill_category_record.update(skill_category_record_params)
            render json: skill_category_record
          else
            render json:  error_response_wrapper(skill_category_record), status: :unprocessable_entity
          end
        end

        def create
        	skill_category_record = candidate.skill_category_records.build(skill_category_record_params)
          if skill_category_record.save
            render json: skill_category_record
          else
            render json: error_response_wrapper(skill_category_record), status: :unprocessable_entity
          end
        end

        def destroy
        	skill_category_record.destroy
        	head :no_content
        end

        def reorder
          if skill_category_record.insert_at(params[:position])
            render json: candidate.skill_category_records, each_serializer: SkillCategoryRecordSerializer, scope: candidate
          else
            head :unprocessable_entity
          end
        end

        private

          def skill_category_record
            @skill_category_record ||= candidate.skill_category_records.find(params[:id])
          end

          def candidate
            @candidate ||= current_user.candidate
          end

          def skill_category_record_params
            allowed_params = [
              :skill_category_id
            ]
            params.permit(allowed_params)
          end
      end
    end
  end
end
