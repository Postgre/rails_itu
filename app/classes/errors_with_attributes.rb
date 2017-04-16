# Finds all ActiveModel::Errors on the provided object and generates a
# hash containing all attributes with errors along with the invalid values
# that generated the validation errors.
#
# Example:
#
#  puts ErrorsWithAttributes.new(user).to_s
#
#  # Results in:
#  #
#  # ---
#  # :email:
#  #  :value: foo@bar.com
#  #  :errors:
#  #  - has already been taken
class ErrorsWithAttributes
  def initialize(obj)
    @obj = obj
  end

  def to_hash
    @obj.errors.to_hash.keys.reduce({}) do |hash, key|
      hash[key] = { value: @obj[key], errors: @obj.errors[key] }
      hash
    end
  end

  def to_s
    to_hash.to_yaml
  end
end
