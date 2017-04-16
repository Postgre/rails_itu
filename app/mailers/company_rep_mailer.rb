class CompanyRepMailer < MailerBase

  def pending_email(company, user)
    @company = company
    @rep_name     = user.full_name
    @company_name = @company.name
    mail(to: user.email, subject: 'Your application to ITU Bridge has been received')
  end

  def accepted_email(company, user)
    @company = company
    @rep_name    = user.full_name
    @company_name = @company.name
    mail(to: user.email, subject: "Congratulations! #{@company_name} has been accepted into ITU Bridge")
  end

  def invited_email(company, user)
    @company      = company
    @rep          = user
    @rep_name     = user.full_name
    @company_name = @company.name
    mail(to: user.email, subject: "You have being invited to join #{@company_name} on ITU Bridge")
  end

  def new_application_email(job_application, user)
    @job_name       = job_application.job_title
    @candidate      = job_application.candidate
    @candidate_name = @candidate.full_name
    @company        = job_application.job.company
    @repName = user.full_name
    mail(to: user.email, subject: "New application for #{@job_name}")
  end

  def canceled_application_email(job_application, user)
    @job_name       = job_application.job_title
    @candidate      = job_application.candidate
    @candidate_name = @candidate.full_name
    @company        = job_application.job.company
    @repName = user.full_name
    mail(to: user.email, subject: "An application for #{@job_name} has been canceled")
  end

  def interview_accepted_email(interview, user)
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    @repName = user.full_name
    mail(to: user.email, subject: "#{@candidate_name} has accepted your interview invitation on ITU Bridge.")
  end

  def interview_rejected_email(interview, user)
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    @repName = user.full_name
    mail(to: user.email, subject: "Your interview invitation for #{@job_name} has been rejected on ITU Bridge")
  end

  def interview_time_rejected_email(interview, user)
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    @repName = user.full_name
    mail(to: user.email, subject: "#{@candidate_name} has rejected offered time of Interview for #{@job_name}")
  end
end
