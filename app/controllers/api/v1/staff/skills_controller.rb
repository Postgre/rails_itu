module API
  module V1
    module Staff
      class SkillsController < ApiController
        def index
          authorize :skill, :index?

          @skills = ::Skill.includes(:skill_category, :skill_records)
          @skills = @skills.search(params[:q] ? JSON.parse(params[:q]) : nil).result
          @skills = @skills.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}") if params[:order]
          @skills = @skills.page(params[:page])
          response.headers['X-total']   = @skills.total_count.to_s
          response.headers['X-offset']  = @skills.offset_value.to_s
          response.headers['X-limit']   = @skills.limit_value.to_s
          render json: @skills,
                 each_serializer: StaffSkillSerializer
        end

        def show
          render json: Skill.find(params[:id]), serializer: StaffSkillDetailSerializer
        end

        def add_skill
          authorize :skill, :add_connected?

          @new_skill = Skill.find(params[:skill_id])

          Skill.find(params[:id]).skill_records.each do |sr|
            sr.skillable.skill_records.where(skill_id: @new_skill.id).first_or_create
          end

          head :ok
        end

        def destroy
          authorize :skill, :delete?

          Skill.find(params[:id]).destroy

          head :ok
        end

        private
          def sort_column
            (::Skill.column_names).include?(params[:order]) ? params[:order] : 'skills.id'
          end
      end
    end
  end
end
