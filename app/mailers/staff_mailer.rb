class StaffMailer < MailerBase
  def pending_company_email(company)
    @company = company
    @url = url_for(controller: 'staff/home', action: 'index', only_path: false) + '#!/companies/' + @company.id.to_s
    mail(to: 'staff1@itu.edu', subject: 'New Company Registration')
  end
end
