module API
  module V1
    module Staff
      class CompaniesController < ApiController
        before_action :find_company, only: [:show, :reject, :accept, :ban, :unban]

        def index
          authorize :company, :index?
          @companies = CompanyPolicy::Scope.new(current_user).resolve
          @companies = @companies.search(params[:q] ? JSON.parse(params[:q]) : nil).result
          if params[:order]
            if params[:order] != 'companies.transition_date'
              @companies = @companies.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, companies.id") if params[:order]
            else
              @companies = @companies.order_by_transition_date(params[:reverse] == 'true')
            end
          end

          @companies = @companies.page(params[:page])
          response.headers['X-total']   = @companies.total_count.to_s
          response.headers['X-offset']  = @companies.offset_value.to_s
          response.headers['X-limit']   = @companies.limit_value.to_s
          render json: @companies,
                 each_serializer: StaffCompanySerializer
        end

        def show
          authorize @company, :show?
          render json: @company, serializer: StaffCompanySerializer
        end

        def reject
          authorize @company, :reject?

          if @company.can_reject?
            @company.reject!
            render json: @company, serializer: StaffCompanySerializer
          else
            head :unprocessable_entity
          end
        end

        def accept
          authorize @company, :accept?

          if @company.can_accept?
            @company.accept!
            render json: @company, serializer: StaffCompanySerializer
          else
            head :unprocessable_entity
          end
        end

        def ban
          authorize @company, :ban?

          if @company.can_ban?
            @company.ban!
            render json: @company, serializer: StaffCompanySerializer
          else
            head :unprocessable_entity
          end
        end

        def unban
          authorize @company, :unban?

          if @company.can_unban?
            @company.unban!
            render json: @company, serializer: StaffCompanySerializer
          else
            head :unprocessable_entity
          end
        end

        private

          def find_company
            @company = ::Company.find(params[:id])
          end

          def sort_column
            (::Company.column_names + ['companies.created_at', 'companies.updated_at', 'companies.transition_date']).include?(params[:order]) ? params[:order] : "companies.id"
          end
      end
    end
  end
end
