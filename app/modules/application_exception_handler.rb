module ApplicationExceptionHandler
  def server_error(exception)
    Rails.logger.error(exception)
    request.format = :json
    render :json => {message: 'Internal server error'}, status: 500
  end

  def record_not_found
    request.format  = :json
    render json: {message: 'The requested resource was not found'}, status: 404
  end

  def method_not_allowed
    request.format = :json
    render json: {error: 'method not allowed'}, status: 405
  end
end
