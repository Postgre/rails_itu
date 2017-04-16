module API
  module V1
    class CommentsController < ApiController
      before_action :find_commentable, only: [:create]

      def create
        authorize @commentable, :comment?

        @comment = Comment.build_from(@commentable, current_user.id, comment_params[:title], comment_params[:body])
        if @comment.save
          if comment_params[:parent_id]
            @parent = @commentable.comment_threads.find(comment_params[:parent_id])
            @comment.move_to_child_of(@parent)
          end

          render json: @commentable, serializer: serializer
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      private
        def serializer
          staff_prefix = ''
          staff_prefix = 'Staff' if current_user.has_role? :staff
          "#{staff_prefix}#{params[:resource].classify}Serializer".constantize
        end

        def find_commentable
          @commentable = params[:resource].classify.constantize.find(params[:resource_id])
          render json: {errors: [I18n.t('errors.messages.non-commentable')]}, status: :unprocessable_entity unless @commentable.respond_to? :root_comments
        end

        def comment_params
          params.require(:comment).permit(:title, :body, :parent_id)
        end
    end
  end
end
