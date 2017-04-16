usa_iso3 = 'USA'
india_iso3 = 'IND'
password = ENV.fetch('TEST_USERS_PWD')

candidates = User.seed(:email,
  {email: 'candidate@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate1@itu.edu', password: password, password_confirmation: password, first_name: 'Handful', last_name: 'Candidate'},
  {email: 'candidate2@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate3@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate4@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate5@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate6@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate7@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate8@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate9@itu.edu', password: password, password_confirmation: password, first_name: 'Empty', last_name: 'Candidate'},
)

candidates.each do |c|
  c.candidate!
  itu_user = ItuIdUser.find(c.itu_id)
  itu_user.remote_avatar_url = 'https://id.itu.edu/test-avatar.png'
  itu_user.save
end

candidates[1].candidate.update_attributes about: "Carrier Experience :Full Stack Ruby on Rails developer with strong knowledge on DBA /Network (Administration)/Engineer/NOC/Security Engineer with the strong background of network Routing Switching and troubleshooting. Very flexible, multi-tasking with the priorities and work independently if needed. Excellent communication and analytical skills. Proficient ability to deal with the customers and resolve their issues. Great problem solving skills and customer relation skills. Experience in planning designing and administrating LAN/WAN, Firewalls, VPN’S and troubleshooting.
Strong Knowledge of Cloud hosting(AmazonAWS,Racks pace)data migration from physical server's to cloud.
DB migration from MySql to MsSql.", city: 'Sunnyvale', country_iso3: usa_iso3

skill_ruby = Skill.where(name: 'Ruby').first
skill_rails = Skill.where(name: 'Ruby on Rails').first

SkillRecord.seed(:skillable_type, :skillable_id, :skill_id,
  {skillable_type: 'Candidate', skillable_id: candidates[1].candidate.id, skill_id: skill_ruby.id},
  {skillable_type: 'Candidate', skillable_id: candidates[1].candidate.id, skill_id: skill_rails.id, is_featured: true}
)

EducationRecord.seed(:candidate_id, :school,
  {candidate_id: candidates[1].candidate.id, school: 'ITU', city: 'San Jose', start_year: 2013,
   degree: 'Master of Business Administration', is_verified: true, country_iso3: usa_iso3},
  {candidate_id: candidates[1].candidate.id, school: 'Jntu', city: 'Hyderbad', start_year: 2007, end_year: 2013,
   degree: 'BS in Computer Science', is_verified: true, country_iso3: india_iso3}
)

EmploymentRecord.seed(:candidate_id, :company_name,
  {candidate_id: candidates[1].candidate.id, company_name: 'International Technological University',
   job_title: "Graduate Teaching Assistant", description: "<p><span>•  Graduate teaching assistant for Introduction to Data Science. Tutoring students on topics covered in class, including assignments and in class projects. </span><br/></p><p>•  Posting course material on the online student portal. Maintain student records, including grading papers, assignments and projects. </p><p>•  Conducting mock interviews via scheduled Skype, phone class apart from in class interviews, to prepare students for the industrial requirement as a junior data scientist. </p><p><br/></p>",
   start_date: "2014-06-01", end_date: nil, is_current_job: true, city: "San Jose", country_iso3: usa_iso3},
  {candidate_id: candidates[1].candidate.id, company_name: 'Cisco',
   job_title: "Software Developer", description: "<p>Environment: Ruby on Rails, Watir API, Celerity API, Zen-desk,Pivotal tracker</p><p>•	Full stack engineer responsible for development of Education Management System</p><p>•	Working extensively with Ruby 1.9.3 and 1.8.7, Ruby on Rails 2.3 and 3.2, and MySql on the backend.</p><p>•	Experience with HTML5, Javascript, CSS3 and Twitter Bootstrap on the front end</p><p>•	Setup and configured automated deployment and scaling infrastructure on Amazon using EC2, S3, Route53, Elastic Load Balancer, and Virtual Private cloud with Ubuntu 12.04 and RHEL 5.5</p><p>•	Administered legacy .net and Ruby on Rails 3.2 applications</p><p>•	Working on Development Operations team to automate day-to-day operations.</p><p>•	Working on integrating external third party API’s to integration into the applications.</p><p>•	Assist other team members in design and building the functionality</p><p>•	Plan design and support UI/UX need's for the Application</p><p>•	Work closely with support team to prioritize and fix production issue's</p><p>•	Planning and conducting a wide range of quality control tests and analysis to ensure that all application products and services meet organizational standards and end-user requirements.&nbsp;</p><p>•	Working on data integration/Migration from MSSQL/Mysql</p>",
   start_date: "2009-01-01", end_date: '2011-01-01', city: "San Jose", country_iso3: usa_iso3},
  {candidate_id: candidates[1].candidate.id, company_name: 'Microsoft',
   job_title: "Software Developer", description: "<p>:-Plan Design and install Linux/Unix Server's/troubleshooting when needed</p><p>:-Plan Design and Implement Network-Routing/Switching/Security Firewall</p><p>:- Firewall's configuration and troubleshooting (Cisco ASA, Sonic wall NSA,Juniper )</p><p>:-Migrate Data from Physical Data Center to Amazon/Rack Space Cloud</p><p>:-Install Mail server's(Google App's,Zimbra,Postfix)</p><p>:-Jenzabar EX,JCIS Info-maker&nbsp;</p><p>:-Configured VPN tunneling (L2tp,PPP,IPsec)</p><p>:-VOIP(Barracuda)</p><p>:-Migrate DB from MYSql to MSSQl (2008 -r2)</p><p>:-Writing complex quires to generate report's&nbsp;</p><p>:-Manage varies team's(Production/Testing)</p><p>:- Managing Backup's in cloud(Snap shot),SAN (Dell , VM Ware),Tape(Symantec Backup Exec)</p><p>:- Monitoring netwrok (Nagios, McAfee )</p>",
   start_date: "2006-02-01", end_date: '2009-01-01', city: "San Jose", country_iso3: usa_iso3}
)

staff_users = User.seed(:email,
  {email: 'staff@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff1@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff2@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff3@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff4@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff5@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff6@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff7@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff8@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
  {email: 'staff9@itu.edu', password: password, password_confirmation: password, first_name: 'Staff', last_name: 'Member'},
)

staff_users.each do |s|
  s.add_role :staff
end
