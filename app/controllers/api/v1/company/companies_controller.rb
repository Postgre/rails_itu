module API
  module V1
    module Company
      class CompaniesController < ApiController
        skip_before_action :authenticate_user!, only: [:create, :show]
        before_action :find_company, except: [:create, :index]

        def index
          @companies = CompanyPolicy::Scope.new(current_user).resolve

          if params[:q]
            q = JSON.parse(params[:q])
            with_jobs = q.delete('with_jobs')
            followed = q.delete('followed')
          else
            q = nil
          end

          @companies = @companies.search(q).result
          @companies = @companies.with_jobs if with_jobs
          @companies = @companies.followed_by(current_user) if followed
          @companies = @companies.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}, companies.id") if params[:order]
          @companies = @companies.page(params[:page])
          response.headers['X-total']   = @companies.total_count.to_s
          response.headers['X-offset']  = @companies.offset_value.to_s
          response.headers['X-limit']   = @companies.limit_value.to_s

          render json: @companies, each_serializer: CompanySerializer, scope: current_user
        end

        def show
          render json: @company, serializer: company_serializer
        end

        def create
          company = ::Company.new(name: company_params[:name], phone_number: company_params[:phone_number])

          if current_user
            user = current_user
          else
            user = User.new(company_params[:users_attributes].try(:[], 0))
            user.save

            sign_in(user) if user.persisted?
          end

          if user.persisted?
            company.company_reps.build(user_id: user.id)

            if company.save
              user.add_role :representative, company

              render json: {company: RepCompanySerializer.new(company), user: UserSerializer.new(user)}, status: :created
            else
              render json: {errors: company.errors, user: user}, status: :unprocessable_entity
            end
          else
            render json: {errors: user.errors}, status: :unprocessable_entity
          end
        end

        def update
          authorize @company, :manage?
          if @company.update_attributes(company_params)
            if @company.can_submit?
              @company.submit
            end

            render json: @company, serializer: RepCompanySerializer
          else
            render json: @company.errors, status: :unprocessable_entity
          end
        end

        def set_logo
          authorize @company, :manage?
          @company.update_attribute :logo, params[:file]

          if @company.can_submit?
            @company.submit
          end

          render json: @company, serializer: RepCompanySerializer
        end

        def drop_logo
          authorize @company, :manage?
          @company.remove_logo!
          @company.save
          head :ok
        end

        def invite
          authorize @company, :manage?

          @rep = User.where(email: params[:representative][:email]).first
          unless @rep
            @rep = User.new(representative_params)
            @rep.save
          end

          if @rep.persisted?
            if @company.users.exists?(email: params[:representative][:email])
              render json: {errors: [I18n.t('roles.company.representative.cant_add_already_existing_rep')]}, status: :unprocessable_entity
            else
              @company.company_reps.build(user_id: @rep.id)
              @company.save
              @rep.add_role :representative, @company
              CompanyRepMailer.delay.invited_email(@company, @rep)
              render json: @company, serializer: RepCompanySerializer
            end
          else
            render json: @rep.errors, status: :unprocessable_entity
          end
        end

        def expel
          authorize @company, :manage?

          @rep = User.find_by!(email: params[:representative][:email])

          if @rep.id != current_user.id
            if @company.company_reps.where(user_id: @rep.id).any?
              @company.company_reps.where(user_id: @rep.id).delete_all
              @rep.remove_role :representative, @company

              render json: @company, serializer: RepCompanySerializer
            else
              render json: {errors: [I18n.t('roles.company.representative.cant_remove_non_existing')]}, status: :unprocessable_entity
            end
          else
            render json: {errors: [I18n.t('roles.company.representative.cant_remove_yourself')]}, status: :unprocessable_entity
          end
        end

        def interviews
          authorize @company, :manage?

          render json: @company.interviews, each_serializer: InterviewSerializer
        end

        def favorite
          if current_user.candidate
            authorize @company, :show?
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: @company.id, subject_type: 'Company').first_or_create

            head :ok
          else
            head :not_found
          end
        end

        def unfavorite
          if current_user.candidate
            authorize @company, :show?
            current_user.candidate.favorites.where(creator_id: current_user.id, subject_id: @company.id, subject_type: 'Company').destroy_all

            head :ok
          else
            head :not_found
          end
        end


        private

          def find_company
            @company = ::Company.find(params[:id])
          end

          def company_params
            params.require(:company).permit(:name,
                        :website,
                        :about_us,
                        :website,
                        :company_size,
                        :industry_id,
                        :country_iso3,
                        :city,
                        :street_address,
                        :street_address2,
                        :phone_number,
                        :postal_code,
                        :region,
                        users_attributes: [
                          :email,
                          :password,
                          :password_confirmation,
                          :first_name,
                          :middle_name,
                          :last_name
                        ])
          end

          def representative_params
            params.require(:representative).permit(
                :email,
                :password,
                :password_confirmation,
                :first_name,
                :middle_name,
                :last_name
            )
          end

          def company_serializer
            Rails.logger.info current_user.inspect
            (current_user.try(:has_role?, :representative, @company)) ? RepCompanySerializer : CompanySerializer
          end

          def sort_column
            (::Company.column_names).include?(params[:order]) ? 'companies.' + params[:order] : 'companies.id'
          end
      end
    end
  end
end
