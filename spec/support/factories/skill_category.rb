FactoryGirl.define do
  factory :skill_category do
    name { Faker::Lorem.word }
    initialize_with { SkillCategory.where(name: name).first_or_create }
  end
end
