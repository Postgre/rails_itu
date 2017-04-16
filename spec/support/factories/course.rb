FactoryGirl.define do
  factory :course do
    candidate { create :candidate }
    title { Faker::Company.catch_phrase }
    semester { Faker::Lorem.word }
    department{ Faker::Lorem.word }
    professor { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    is_visible { true }
    grade { "10" }
  end
end
