module API
  module V1
    class SkillLevelsController < ApiController
      skip_before_action :authenticate, only: [:index]
      def index
        render json: SkillRecord::SKILL_LEVELS.to_json, status: 200
      end
    end
  end
end
