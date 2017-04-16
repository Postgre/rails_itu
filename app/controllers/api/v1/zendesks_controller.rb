module API
  module V1
    class ZendesksController < ApiController
      skip_before_action :authenticate_user!

      def create
        if user_signed_in?
          email = current_user.email
          name = current_user.full_name
        else
          email = params[:email]
          name = params[:name]
        end

        zendesk = {subject: params[:subject],
                  comment: {value: params[:body]},
                  requester: {
                    email: email,
                    name: name
                  }}
        response = ZendeskAPI::Ticket.create(Rails.application.config.zendesk, zendesk)
        if response.present? && response.id.present?
          head :ok
        else
          Rails.logger.info response.inspect
          head :unprocessible_entity
        end
      end
    end
  end
end