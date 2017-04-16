require 'ffaker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities:  City.create([{ name: 'Chicago',, { name: 'Copenhagen',])
#   Mayor.create(name: 'Emanuel', city: cities.first)

timeZones = [
    {name: '(GMT+4:00) Moscow'},
    {name: '(GMT+5:00) Islamabad'},
    {name: '(GMT+6:00) Dhaka'},
    {name: '(GMT+7:00) Bangkok'},
    {name: '(GMT+8:00) Singapore'},
    {name: '(GMT+9:00) Tokyo'}
]


skillCategories = [
    { name: 'Management' },
    { name: 'Programming' },
    { name: 'Business Communication' },
    { name: 'Information Technology' },
    { name: 'Design' },
    { name: 'Commerce' },
    { name: 'Psychology' }
]

skills = [
    { name: 'Business development' },
    { name: 'Staff management' },
    { name: 'Strategy planning' },
    { name: 'JavaScript' },
    { name: 'C#' },
    { name: 'Ruby' },
    { name: 'HTML' },
    { name: 'Meetings' },
    { name: 'Presentations' },
    { name: 'Negotiations' },
    { name: 'Conflict resolution' }
]

skillLevels = [
    { value: 0, name: 'Beginner' },
    { value: 1, name: 'Intermediate' },
    { value: 2, name: 'Good' },
    { value: 3, name: 'Strong' },
    { value: 4, name: 'Expert' }
]

candidateAvailabilityOptions = [
    { value: 'not_available', name: 'Not available' },
    { value: 'available_full_time', name: 'Available for full-time' },
    { value: 'available_part_time', name: 'Available for part-time only' }
]

categorizedSkills = [
    {
        name: 'Management',
        skills_attributes: [
            {  name: 'Business development' },
            { name: 'Staff management' },
            { name: 'Strategy planning' }
        ]
    },
    {
        name: 'Programming',
        skills_attributes: [
            { name: 'JavaScript' },
            { name: 'C#' },
            { name: 'Ruby' },
            {  name: 'HTML' }
        ]
    },
    {
        name: 'Business Communication',
        skills_attributes: [
            { name: 'Meetings' },
            { name: 'Presentations' },
            { name: 'Negotiations' },
            { name: 'Conflict resolution' }
        ]
    },
    {
        name: 'Information Technology',
        skills_attributes: [
            { name: 'Agile' },
            { name: 'Databases' },
            { name: 'Scrum' },
            {  name: 'Extreme Programming' },
            { name: 'OLAP' },
            {  name: 'IT Security' }
        ]
    }
]

candidateFeaturedSkillRecords = [
    { id: 11, skillId: 11, skillName: 'Business development', yearsOfExperience: 7, level: 3, isFeatured: true },
    { id: 12, skillId: 12, skillName: 'Staff management',     yearsOfExperience: 8, level: 4, isFeatured: true },
    { id: 13, skillId: 13, skillName: 'Strategy planning',    yearsOfExperience: 5, level: 2, isFeatured: true },
    { id: 21, skillId: 21, skillName: 'JavaScript', yearsOfExperience: 10, level: 4, isFeatured: true },
    { id: 22, skillId: 22, skillName: 'C#',         yearsOfExperience: 7,  level: 3, isFeatured: true },
    { id: 23, skillId: 23, skillName: 'Ruby',       yearsOfExperience: 1,  level: 2, isFeatured: true },
    { id: 24, skillId: 24, skillName: 'HTML',       yearsOfExperience: 12, level: 4, isFeatured: true },
    { id: 31, skillId: 31, skillName: 'Meetings',      yearsOfExperience: 10, level: 4, isFeatured: true },
    { id: 32, skillId: 32, skillName: 'Presentations', yearsOfExperience: 12,  level: 3, isFeatured: true },
    { id: 33, skillId: 33, skillName: 'Negotiations',  yearsOfExperience: 12,  level: 4, isFeatured: true },
    { id: 34, skillId: 34, skillName: 'Conflict resolution', yearsOfExperience: 7, level: 3, isFeatured: true }
]

candidateSkillRecords = [
    {
        id: 1,
        skillCategoryName: 'Management',
        skillCategoryId: 1,
        skillRecords: [
            { id: 11, skillId: 11, skillName: 'Business development', yearsOfExperience: 7, level: 3, isFeatured: true },
            { id: 12, skillId: 12, skillName: 'Staff management',     yearsOfExperience: 8, level: 4, isFeatured: false },
            { id: 13, skillId: 13, skillName: 'Strategy planning',    yearsOfExperience: 5, level: 2, isFeatured: false }
        ]
    },

    {
        id: 2,
        skillCategoryName: 'Programming',
        skillCategoryId: 2,
        skillRecords: [
            { id: 21, skillId: 21, skillName: 'JavaScript', yearsOfExperience: 10, level: 4, isFeatured: true },
            { id: 22, skillId: 22, skillName: 'C#',         yearsOfExperience: 7,  level: 3, isFeatured: false },
            { id: 23, skillId: 23, skillName: 'Ruby',       yearsOfExperience: 1,  level: 2, isFeatured: true },
            { id: 24, skillId: 24, skillName: 'HTML',       yearsOfExperience: 12, level: 4, isFeatured: false }
        ]
    },

    {
        id: 3,
        skillCategoryName: 'Business Communication',
        skillCategoryId: 3,
        skillRecords: [
            { id: 31, skillId: 31, skillName: 'Meetings',      yearsOfExperience: 10, level: 4, isFeatured: true },
            { id: 32, skillId: 32, skillName: 'Presentations', yearsOfExperience: 12,  level: 3, isFeatured: false },
            { id: 33, skillId: 33, skillName: 'Negotiations',  yearsOfExperience: 12,  level: 4, isFeatured: true },
            { id: 34, skillId: 34, skillName: 'Conflict resolution', yearsOfExperience: 7, level: 3, isFeatured: true }
        ]
    }
]

candidates = {
    profile_note: "Masters degree in Computer Science and Economics",
    about: "Updated description. John Doe is John Doe, no one ever seen him nor able to catch in any way",
    country_id: [10, 12, 34, 2].sample,
    city: Faker::Address::city,
    schedule_available: "available_full_time"
}

candidate_users = User.create([
                                  {email: 'can1@email.com',
                                   first_name: Faker::Name.first_name,
                                   last_name: Faker::Name.last_name,
                                   itu_id: "#{Random.rand Time.now.to_i}",
                                   phone_number: "#{Faker::PhoneNumber.phone_number}",
                                   password: SecureRandom.hex,
                                   password_confirmation:  SecureRandom.hex
                                   },

                                  {email: 'can2@email.com',
                                   first_name: Faker::Name.first_name,
                                   last_name: Faker::Name.last_name,
                                   itu_id: "#{Random.rand Time.now.to_i}",
                                   phone_number: "#{Faker::PhoneNumber.phone_number}",
                                   password: SecureRandom.hex,
                                   password_confirmation:  SecureRandom.hex
                                   },

                                  {email: 'can3@email.com',
                                   first_name: Faker::Name.first_name,
                                   last_name: Faker::Name.last_name,
                                   itu_id: "#{Random.rand Time.now.to_i}",
                                   phone_number: "#{Faker::PhoneNumber.phone_number}",
                                   password: SecureRandom.hex,
                                   password_confirmation:  SecureRandom.hex
                                   },

                                  {email: 'can4@email.com',
                                   first_name: Faker::Name.first_name,
                                   last_name: Faker::Name.last_name,
                                   itu_id: "#{Random.rand Time.now.to_i}",
                                   phone_number: "#{Faker::PhoneNumber.phone_number}",
                                   password: SecureRandom.hex,
                                   password_confirmation:  SecureRandom.hex
                                   }
                              ])

CountryList.all.each do |country_list|
  country = Country.new(name: country_list[0], country_code: country_list[1])
  country.save
end

candidate_users.each do |candidate_user|
  Candidate.create!(
      {
          user_id: candidate_user.id
      }.merge(candidates)
  )

  raise FactoryGirl.build(:candidate, user: candidate_user).inspect
end


c=Candidate.first

TimeZone.create(timeZones)

SkillCategory.create(categorizedSkills)

SkillCategory.create(categorizedSkills)

SkillCategory.all.each do |skill_category|
  skill_category.skills.each do |skill|
    skill.skill_records.create!({
                                    level: Random.rand(4),
                                    years_of_experience: Random.rand(10),
                                    is_featured: [true, false].sample,
                                    skillable_type: 'Candidate',
                                    skillable_id: c.id
                                })
  end
end
