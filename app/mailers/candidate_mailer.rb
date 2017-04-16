class CandidateMailer < MailerBase
  def rejected_application_email(job_application)
    @candidate      = job_application.candidate
    @candidate_name = @candidate.full_name
    @job_name       = job_application.job_title
    @company_name   = job_application.company_name
    mail(to: @candidate.email, subject: "Your job application was rejected by #{@company_name}")
  end

  def interview_invite_email(interview)
    @interview      = interview
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    mail(to: @candidate.email, subject: "Congratulations! You have been invited to an interview.")
  end

  def interview_canceled_email(interview)
    @interview      = interview
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    mail(to: @candidate.email, subject: "Your interview invitation has been cancelled")
  end

  def hired_email(interview)
    @interview      = interview
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    mail(to: @candidate.email, subject: "Congratulations! You have been hired by #{@company_name}")
  end

  def time_confirmed_email(interview)
    @interview      = interview
    @candidate      = interview.candidate
    @candidate_name = @candidate.full_name
    @job_name       = interview.job.title
    @company_name   = interview.company.name
    mail(to: @candidate.email, subject: "Time change of Interview for a #{@job_name} has being confirmed by Company")
  end

  def recommended_job_email(favorite)
    @job            = favorite.subject
    @staff          = User.find(favorite.creator_id)
    @staff_name     = @staff.full_name
    @candidate      = favorite.owner
    @candidate_name = @candidate.full_name
    @job_name       = @job.title
    @company_name   = @job.company.name
    mail(to: @candidate.email, subject: "#{@staff_name} has recommended '#{@job_name}' position to you")
  end
end
