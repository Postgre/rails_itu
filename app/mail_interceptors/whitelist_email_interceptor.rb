# In non-production enviornments, this class is responsible for ensuring
# emails are never sent to non-whitelisted addresses.
#
# Additionally, passed through this filter will be prefixed with a tag
# indicating the application environment running at the time a given
# email was sent.
class WhitelistEmailInterceptor
  attr_accessor :logger
  attr_accessor :subject_prefix

  attr_reader :config
  attr_reader :whitelist

  NO_EMAILS_WHITELISTED =
    'Outbound emails are being intercepted, but no emails are whitelisted'
  BLOCKED_OUTBOUND_EMAIL = 'Blocked an outbound email for: %s'
  FILTERED_OUTBOUND_EMAIL = 'Filtered an outbound email for: %s'

  # @param [String] config Path to a YAML file containing
  #   an array of whitelisted emails
  # @param optional [String] prefix A string prefixed
  #   to all email subject fields
  def initialize(config: nil, prefix: nil)
    @logger = Rails.logger
    @whitelist = load_whitelist_from_config(config) || []
    @whitelist += load_whitelist_from_env
    @whitelist  = @whitelist.uniq.freeze

    taggged_log(NO_EMAILS_WHITELISTED, log_level: :warn) if whitelist.empty?

    return if Rails.env.production?
    @subject_prefix = prefix || default_subject_prefix
  end

  def delivering_email(message)
    valid_recipients   = extract_valid_emails(message.to)
    invalid_recipients = valid_recipients - message.to

    # Do not deliver an email that has no valid recipients
    if valid_recipients.size == 0
      message.perform_deliveries = false
      taggged_log format(BLOCKED_OUTBOUND_EMAIL, invalid_recipients.join(', '))

    # If a subset of the message recipients are valid,
    # only send this email to that subset
    elsif invalid_recipients.size > 0
      message.to = valid_recipients

      taggged_log format(FILTERED_OUTBOUND_EMAIL, invalid_recipients.join(', '))
    end

    message.subject = (@subject_prefix + message.subject) if @subject_prefix
  end

  private

  def taggged_log(message = nil, log_level: :debug)
    if block_given?
      logger.tagged(self.class.name) { yield }

    else
      logger.tagged(self.class.name) { logger.send(log_level, message) }
    end
  end

  def load_whitelist_from_config(path)
    return [] unless path.present?

    unless File.exist?(path)
      fail format('Unable to load YAML configuration file: %s', path)
    end

    YAML.load_file(path)
  end

  def load_whitelist_from_env
    return [] unless ENV['WHITELIST_EMAILS'].present?
    ENV['WHITELIST_EMAILS'].to_s.split(',').map(&:strip).reject(&:blank?)
  end

  def default_subject_prefix
    if Rails.env.development?
      '[DEV] '
    elsif Rails.env.staging?
      '[STAGING] '
    else
      format('[%s]', Rails.env)
    end
  end

  # @param [Array<String>] emails A list of email addresses to filter
  # @return [Array<String>] a list of valid emails
  def extract_valid_emails(emails)
    valid_emails = []

    emails.each do |email|
      @whitelist.each do |filter|
        if filter.is_a?(String)
          valid_emails << email if email == filter
        elsif filter.is_a?(Regexp)
          valid_emails << email if email =~ filter
        end
      end
    end
  end
end