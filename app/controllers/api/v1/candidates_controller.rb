module API
  module V1
    class CandidatesController < ApiController
      before_action :find_candidate, only: [:show, :favorite, :unfavorite]
      before_action :find_company, only: [:favorite, :unfavorite]

      def show
        authorize @candidate, :show?
        scope = current_user
        scope = Job.find(params[:job_id]) if params[:job_id]
        render json: @candidate, serializer: CandidateSerializer, scope: scope
      end

      def favorite
        authorize @company, :manage?
        @company.favorited_candidates.push @candidate

        head :ok
      end

      def unfavorite
        authorize @company, :manage?
        @company.favorited_candidates.delete(@candidate)

        head :ok
      end

      def search
        @candidate_search = ::Candidate.do_search(params)
        Rails.logger.info @candidate_search.inspect
        render json: ActiveModel::ArraySerializer.new(@candidate_search.results,
                                                      root: 'candidates',
                                                      each_serializer: CandidateSerializer,
                                                      meta: @candidate_search.meta)
      end

      def suggest
        render json: Skill.lookup(params[:query],
                                  fields: [{ name: :text_start }],
                                  limit: 10).pluck(:name)
      end

      def recommended
        job = ::Job.find(params[:job_id]) unless params[:job_id].nil?
        if job && job.skill_records.size > 0
          candidates = ::Candidate.matching_job_skills(job)
          render json: candidates, each_serializer: CandidateSerializer, scope: job
        else
          render json: []
        end
      end

      private

      def find_candidate
        @candidate = ::Candidate.find(params[:id])
      end

      def find_company
        @company = ::Company.find(params[:company_id])
      end
    end
  end
end
