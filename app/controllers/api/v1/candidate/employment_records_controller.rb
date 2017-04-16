module API
  module V1
    module Candidate
      class EmploymentRecordsController < ApiController

        def show
          render json: employment_record
        end

        def index
          render json: candidate.employment_records
        end

        def create
          employment_record = candidate.employment_records.build(employment_record_params)
          if employment_record.save
            render json: employment_record
          else
            render json: employment_record.errors, status: :unprocessable_entity
          end
        end

        def update
          if employment_record.update_attributes(employment_record_params)
            render json: employment_record
          else
            render json: employment_record.errors, status: :unprocessable_entity
          end
        end

        def destroy
          employment_record.destroy
          head 204
        end

        private

          def employment_record
            @employment_record  ||= candidate.employment_records.find(params[:id])
          end

          def candidate
            @candidate ||= current_user.candidate
          end

          def employment_record_params
            params.permit(
              :company_name,
              :job_title,
              :description,
              :website,
              :start_date,
              :end_date,
              :city,
              :country_iso3,
              :is_current_job,
              :start_date,
              :end_date,
              :region
            )
          end
      end
    end
  end
end
