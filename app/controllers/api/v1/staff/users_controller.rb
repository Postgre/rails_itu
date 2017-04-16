module API
  module V1
    module Staff
      class UsersController < ApiController
        before_action :find_user, only: [:show, :become]

        def index
          authorize :user, :index?

          if params[:q]
            q      = JSON.parse(params[:q])
            roles  = q.delete('roles')
            @users = user_collection.search(q).result
            @users = @users.with_role(roles.to_sym, :any) if roles
          else
            @users = user_collection
          end

          @users = @users.order("#{sort_column} #{params[:reverse] == 'true' ? 'desc' : 'asc'}") if params[:order]
          @users = @users.page(params[:page])
          response.headers['X-total']   = @users.total_count.to_s
          response.headers['X-offset']  = @users.offset_value.to_s
          response.headers['X-limit']   = @users.limit_value.to_s

          render json: @users,
                 each_serializer: StaffUserSerializer
        end

        def show
          authorize @user, :show?
          render json: @user, serializer: StaffUserSerializer
        end

        def become
          authorize :user, :become?
          session[:current_admin_user_id] = current_user.id
          sign_in(@user)
          render json: current_user, serializer: CurrentUserSerializer
        end

        private

          def user_collection
           User.includes(:roles, :candidate)
          end

          def find_user
            @user = User.find(params[:id])
          end

          def sort_column
            [User.column_names].include?(params[:order]) ? params[:order] : 'email'
          end
      end
    end
  end
end
