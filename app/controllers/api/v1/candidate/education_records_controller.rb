module API
  module V1
    module Candidate
      class EducationRecordsController < ApiController

        def show
          render json: education_record
        end

        def index
          render json: candidate.education_records, each_serializer: EducationRecordSerializer, root: false, status: 200
        end

        def create
          education_record = candidate.education_records.build(education_record_params)
          if education_record.save
            render json: education_record, serializer: EducationRecordSerializer, root: false, status: 201
          else
            render json: education_record.errors, status: :unprocessable_entity
          end
        end

        def update
          if education_record.update(education_record_params)
            render json: education_record, serializer: EducationRecordSerializer, root: false, status: 200
          else
            render json: education_record.errors, status: :unprocessable_entity
          end
        end

        def destroy
          education_record.destroy
          head 204
        end

        private

          def education_record
            @education_record  ||= candidate.education_records.find(params[:id])
          end

          def candidate
            @candidate ||= current_user.candidate
          end

          def education_record_params
            params.permit(
              :start_year,
              :end_year,
              :degree,
              :field_of_study,
              :grade,
              :description,
              :school,
              :city,
              :country_iso3,
              :region
            )
          end
      end
    end
  end
end
