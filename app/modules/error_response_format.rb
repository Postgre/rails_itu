# Expected
# "error": {
#   "status": 422,
#   "code": "some_object/validation",
#   "message": "Cannot create the {some_object} because provided data is not valid",
#   "details": "More thorough description of a problem and probably even solution for curious users",
#   "href": "http://some.url/to-describe/the-problem/in-even-more-details/optional",
#   "errors": {
#     "name": {
#       "code": "validation/missing_required",
#       "message": "The name is blank."
#     },
#     "email": {
#       "code": "validation/invalid_format",
#       "message": "The email format is invalid."
#     },
#     "description": {
#       "code": "validation/invalid_value/too_short",
#       "message": "The description is too short. Please provide more details."
#     }
#   }
# }
#simplified version of error response handling
#this requires some work.. but an ok start
module ErrorResponseFormat

  def error_response_wrapper(object, status = 422, options = {})
    self.status = status
    error_obj, code_types, @messages = ErrorResponseFormatter.new(object).show
    code = ErrorCodeFormatter.new(code_types).show
    {
        status: status,
        code: code,
        #message: "Cannot add #{object.class.to_s.downcase} because some input is not correct",
        messages: @messages.flatten,
        href: request.url,
        fieldErrors: error_obj
    }
  end

  def messages
    @messages
  end

  class ErrorCodeFormatter
    def initialize(codes)
      @codes = codes.flatten.uniq.join(' / ') if codes.is_a? Array
    end

    def show
      @codes || ''
    end
  end

  class ErrorResponseFormatter
    def initialize(object)
      @object = object
    end

    def show
      errors_array ||= []
      messages ||= []
      code_types ||= []
      error_hash ||= {}
      if @object.errors.is_a? ActiveModel::Errors
        @object.errors.messages.each do |attribute, message|
          messages << message
          error_hash[attribute] ||= {
              message: message
          }
          error_hash[attribute].merge!(@object.errors.custom_messages[attribute]) if @object.errors.custom_messages[attribute]
          code_types << @object.errors.custom_messages[attribute][:error_code]
        end
        errors_array << error_hash
      end
      [errors_array, code_types, messages]
    end
  end
end
