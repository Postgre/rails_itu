Dir[Rails.root.join("spec/support/factories/**/*.rb")].each { |f| require f }

usa_iso3 = 'USA'
india_iso3 = 'IND'

candidates = User.seed(:email,
  {email: 'candidate@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate'},
  {email: 'candidate1@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Handful', last_name: 'Candidate1'},
  {email: 'candidate2@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate2'},
  {email: 'candidate3@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate3'},
  {email: 'candidate4@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate4'},
  {email: 'candidate5@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate5'},
  {email: 'candidate6@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate6'},
  {email: 'candidate7@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate7'},
  {email: 'candidate8@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate8'},
  {email: 'candidate9@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Empty', last_name: 'Candidate9'},
  {email: 'candidate10@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate10'},
  {email: 'candidate11@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Handful', last_name: 'Candidate11'},
  {email: 'candidate12@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate12'},
  {email: 'candidate13@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate13'},
  {email: 'candidate14@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate14'},
  {email: 'candidate15@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate15'},
  {email: 'candidate16@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate16'},
  {email: 'candidate17@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate17'},
  {email: 'candidate18@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate18'},
  {email: 'candidate19@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Empty', last_name: 'Candidate19'},
  {email: 'automationcandidate@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation', last_name: 'Candidate'},
  {email: 'automationcandidate1@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation1', last_name: 'Candidate'},
  {email: 'automationcandidate2@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation2', last_name: 'Candidate'},
  {email: 'automationcandidate3@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation3', last_name: 'Candidate'},
  {email: 'automationcandidate4@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation4', last_name: 'Candidate'},
  {email: 'automationcandidate5@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation5', last_name: 'Candidate'},
  {email: 'automationcandidate6@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation6', last_name: 'Candidate'},
  {email: 'automationcandidate7@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation7', last_name: 'Candidate'},
  {email: 'automationcandidate8@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation8', last_name: 'Candidate'},
  {email: 'automationcandidate9@itu.edu', password: 'p@ssword1', password_confirmation: 'p@ssword1', first_name: 'Automation9', last_name: 'Candidate'},
  {email: 'UXcandidate1@itu.edu', password: '0g4j0', password_confirmation: '0g4j0', first_name: 'Student', last_name: 'One'},
  {email: 'UXcandidate2@itu.edu', password: 'AYCJ5', password_confirmation: 'AYCJ5', first_name: 'Student', last_name: 'Two'},
  {email: 'UXcandidate3@itu.edu', password: 'jpdna', password_confirmation: 'jpdna', first_name: 'Student', last_name: 'Three'},
  {email: 'UXcandidate4@itu.edu', password: 'FBnjn', password_confirmation: 'FBnjn', first_name: 'Student', last_name: 'Four'},
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
skill_padrino = Skill.where(name: 'Padrino').first

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
  {email: 'staff1@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member1'},
  {email: 'staff2@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member2'},
  {email: 'staff3@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member3'},
  {email: 'staff4@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member4'},
  {email: 'staff5@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member5'},
  {email: 'staff6@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member6'},
  {email: 'staff7@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member7'},
  {email: 'staff8@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member8'},
  {email: 'staff9@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member9'},
  {email: 'staff10@itu.edu', password: 'st@ffp@ssword', password_confirmation: 'st@ffp@ssword', first_name: 'Staff', last_name: 'Member10'},
  {email: 'staff11@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member11'},
  {email: 'staff12@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member12'},
  {email: 'staff13@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member13'},
  {email: 'staff14@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member14'},
  {email: 'staff15@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member15'},
  {email: 'staff16@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member16'},
  {email: 'staff17@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member17'},
  {email: 'staff18@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member18'},
  {email: 'staff19@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member19'},
  {email: 'staff20@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Staff', last_name: 'Member20'},
  {email: 'automationstaff@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation', last_name: 'Staffer'},
  {email: 'automationstaff1@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation1', last_name: 'Staffer'},
  {email: 'automationstaff2@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation2', last_name: 'Staffer'},
  {email: 'automationstaff3@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation3', last_name: 'Staffer'},
  {email: 'automationstaff4@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation4', last_name: 'Staffer'},
  {email: 'automationstaff5@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation5', last_name: 'Staffer'},
  {email: 'automationstaff6@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation6', last_name: 'Staffer'},
  {email: 'automationstaff7@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation7', last_name: 'Staffer'},
  {email: 'automationstaff8@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation8', last_name: 'Staffer'},
  {email: 'automationstaff9@itu.edu', password: 'st@ffp@ssword1', password_confirmation: 'st@ffp@ssword1', first_name: 'Automation9', last_name: 'Staffer'},
)

staff_users.each do |s|
  s.add_role :staff
  itu_user = ItuIdUser.find(s.itu_id)
  itu_user.remote_avatar_url = 'https://id.itu.edu/test-avatar.png'
  itu_user.save
end

Course.seed(:title, :candidate_id,
  {candidate_id: candidates[1].candidate.id,
   title: "Advertising Copywriting", description: "I learned what went into creating copy in advertising and the concepts and strategy that went into it.", semester: "Winter 2014",
   professor: "Tanya Ryan", department: "Mass Communication 360", grade: "9"},
   {candidate_id: candidates[1].candidate.id,
    title: "Media Planning and Buying", description: "I learned the process of how planning and buying works in the advertising world and created a media plan for a company", semester: "Summer 2014",
    professor: "Tanya Ryan", department: "Mass Communication 361", grade: "8"}
)

company_users = User.seed(:email,
  {email: 'company@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company1@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company2@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company3@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company4@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company5@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company6@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company7@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company8@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
  {email: 'company9@itu.edu', password: 'p@ssword', password_confirmation: 'p@ssword', first_name: 'Company', last_name: 'Member'},
)

companies = []

company_users.each do |user|

  industry = Industry.all.sample
  company_hash =  {name: "Test Company for user #{user.email}",
  website:Faker::Internet.domain_name,
  about_us:Faker::Lorem.sentence(3),
  status:0,
  street_address:Faker::Lorem.sentence(3),
  city:Faker::Lorem.word,
  postal_code:Faker::Lorem.word,
  state:"accepted",
  country_iso3:Carmen::Country.all[rand(0..(Carmen::Country.all.size-1))].alpha_3_code,
  industry_id: industry.id,
  logo: 'https://id.itu.edu/test-avatar.png',
  users: []
  }

  user.company_reps.delete
  user.roles.delete
  company = Company.seed(:name, company_hash)
  user.companies << company
  user.add_role :representative, company[0]
  companies << company[0]
end

# Changing status so it'd be possible to see some sample dates
companies[2].fire_events(:ban)
companies[3].fire_events(:ban)

jobs = Job.seed(:title, :company_id,
  FactoryGirl.build(:job, title: "Test job 1", company: company_users[0].companies[0]).attributes.delete_if{|k| ['id'].include? k},
  FactoryGirl.build(:job, title: "Test job 2", company: company_users[0].companies[0]).attributes.delete_if{|k| ['id'].include? k},
  FactoryGirl.build(:job, title: "Test job 3", company: company_users[0].companies[0]).attributes.delete_if{|k| ['id'].include? k}
)

skill_records = SkillRecord.seed(:skillable_type, :skillable_id, :skill_id,
  {skillable_type: 'Job', skillable_id: jobs[0].id, skill_id: skill_ruby.id, position:1},
  {skillable_type: 'Job', skillable_id: jobs[0].id, skill_id: skill_rails.id, is_featured: true, position: 3},
  {skillable_type: 'Job', skillable_id: jobs[1].id, skill_id: skill_ruby.id, position: 2},
  {skillable_type: 'Job', skillable_id: jobs[1].id, skill_id: skill_rails.id, is_featured: true, position:1},
  {skillable_type: 'Job', skillable_id: jobs[1].id, skill_id: skill_padrino.id, is_featured: true, position: 3},
  {skillable_type: 'Job', skillable_id: jobs[2].id, skill_id: skill_rails.id, is_featured: true, position: 1}
)

skill_records.each do |sr|
  skill_category_records = SkillCategoryRecord.seed(:skill_category_id, :skill_categorizable_type, :skill_categorizable_id,
    {skill_category_id: sr.skill.skill_category_id, skill_categorizable_type: sr.skillable_type, skill_categorizable_id: sr.skillable_id}
  )
  sr.update_attribute :skill_category_record_id, skill_category_records[0].id
end

Interview.seed(:candidate_id, :job_id, :company_id, FactoryGirl.build(:interview, candidate: company_users[1].candidate, company: company_users[0].companies[0], job: jobs[0]).attributes.delete_if{|k| ['id'].include? k})

Favorite.seed(:creator_id, :subject_id, :subject_type, :owner_id,
  {creator_id: candidates[1].id, subject_id: jobs[1].id, subject_type: 'Job', owner_id: candidates[1].candidate.id, owner_type: 'Candidate'},
  {creator_id: staff_users[1].id, subject_id: jobs[1].id, subject_type: 'Job', owner_id: candidates[1].candidate.id, owner_type: 'Candidate'})

JobApplication.seed(:job_id, :candidate_id, job_id: jobs[0].id, candidate_id: candidates[1].candidate.id)

