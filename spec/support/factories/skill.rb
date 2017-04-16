# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :skill do
    name { Faker::Lorem.word }
    skill_category { FactoryGirl.create :skill_category }
    initialize_with { Skill.where(name: name).first_or_create }
  end
end
