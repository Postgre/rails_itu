module API
  module V1
    class ReceiptsController < ApiController
      before_action :find_conversation, only: [:mark_as_read]

      def mark_as_read
        @conversation.receipts.find(params[:id]).mark_as_read
        head :ok
      end

      private
        def find_conversation
          @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
        end
    end
  end
end
