class MailerBase < ActionMailer::Base
  default from: format('ITU Bridge <%s>', 'bridge@itu.edu')
end
