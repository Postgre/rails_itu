module Pubapi
  class CandidatesController < BasePublicController
    swagger_controller :candidates, 'Candidate Management'
    def index
      @candidates = ::Candidate.all.page(@page).per(@limit)
      render json: @candidates, each_serializer: CandidateSerializer, token: true
    end

    swagger_api :index do
      summary 'List of candidates'
      param :query, :app_id, :string, :required, 'Application id'
      param :query, :page, :integer, :optional, 'Page number'
      param :query, :limit, :integer, :optional, 'Per Page'
      response :ok
      response :unauthorized
      response :not_acceptable
      response :not_found
      response :requested_range_not_satisfiable
    end

    def show
      @candidate = ::Candidate.find(params[:id])
      render json: @candidate, serializer: CandidateSerializer, token: true
    end

    swagger_api :show do
      summary 'Get candidate'
      param :query, :app_id, :string, :required, 'Application id'
      param :path, :id, :string, :required, 'Pass candidate id that you will get from candidate list api'
      response :ok
      response :unauthorized
      response :not_acceptable
      response :not_found
      response :requested_range_not_satisfiable
    end
    end
  end
