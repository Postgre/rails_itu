module API
  module V1
    class ConversationsController < ApiController
      before_action :find_conversation, only: [:show, :reply, :mark_as_read]

      def index
        render json: current_user.mailbox.conversations, each_serializer: ConversationSerializer, scope: current_user
      end

      def create
        authorize :user, :message?
        @conversation = current_user.send_message(User.find(params[:user_id]), params[:body], params[:subject])
        render json: @conversation, serializer: ReceiptSerializer, scope: current_user
      end

      def reply
        @conversation = current_user.reply_to_conversation(@conversation, params[:body])
        render json: @conversation, serializer: ReceiptSerializer, scope: current_user
      end

      def mark_as_read
        @conversation.mark_as_read(current_user)
        render json: {unread: current_user.mailbox.inbox(read: false).count(:id, distinct: true)}
      end

      private
        def find_conversation
          @conversation = current_user.mailbox.conversations.find(params[:id])
        end
    end
  end
end
