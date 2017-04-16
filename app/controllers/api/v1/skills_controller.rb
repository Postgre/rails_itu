module API
  module V1
    class SkillsController < ApiController
      skip_before_action :authenticate

      def index
        #TODO we should move to a faster search tool; works for beta
        skills = Skill.unscoped
        skills = skills.where(['lower(name) like ?', "#{params[:query].downcase}%"]) if params[:query]
        skills = skills.order("FIELD(#{(['skill_category_id'] + params[:category_ids].delete_if{|n| false if Float(n) rescue true}).join(',')}) DESC") if params[:category_ids]
        skills = skills.where.not(id: params[:skill_ids]) if params[:skill_ids]

        render json: skills, each_serializer: SkillSerializer
      end

      def create
        @skill = Skill.new(skill_params)
        @skill.skill_category_id = SkillCategory.where(name: 'Other').first.id # TODO: make more reliable way of getting that.

        if @skill.save
          render json: @skill, serializer: SkillSerializer
        else
          render json: @skill.errors, status: :unprocessable_entity
        end
      end

      private

        def skill_params
          params.require(:skill).permit(:name)
        end
    end
  end
end
