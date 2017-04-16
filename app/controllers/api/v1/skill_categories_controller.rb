module API
  module V1
    class SkillCategoriesController < ApiController
      before_action :find_category, only: [:show, :skills]

      def index
        render json: SkillCategory.all
      end

      def show
        render json: @skill_category
      end

      def skills
        skills = @skill_category.skills
        skills = skills.where(['LOWER(name) LIKE ?', "#{params[:query].downcase}%"]) if params[:query]
        render json: skills
      end

      def find_category
        @skill_category = SkillCategory.find(params[:id])
      end
    end
  end
end
