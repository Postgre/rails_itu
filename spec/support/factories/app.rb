FactoryGirl.define do

  factory :app do
    name { Faker::Company.name }
  end
end
