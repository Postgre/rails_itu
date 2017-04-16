module API
  module V1
    module Candidate
      class CoursesController < ApiController

        def show
          render json: course, serializer: CourseSerializer
        end

        def index
          render json: candidate.courses, each_serializer: CourseSerializer
        end

        def update
          if course.update(course_params)
            render json: course, serializer: CourseSerializer, status: :ok
          else
            render json: {errors: course.errors}, status: :unprocessable_entity
          end
        end

        private

          def course
            @course  ||= candidate.courses.find(params[:id])
          end

          def candidate
            @candidate ||= current_user.candidate
          end


          def course_params
            params.permit(
              :is_visible
            )
          end
      end
    end
  end
end
