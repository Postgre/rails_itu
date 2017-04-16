# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
    prefix { Faker::Name.prefix }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'foofoobar'
    password_confirmation 'foofoobar'
    sequence(:email) { |n| "fake_address_#{n}@itu.edu" }
    city { Faker::Address.city }
    phone_number {Faker::PhoneNumber.phone_number }
    time_zone '(GMT-05:00) Eastern Time (US & Canada)'
    is_superuser false
    sequence(:itu_id) { |n| n }

    trait :john do
      first_name 'John'
      last_name 'Doe'
    end

    trait :staff do
      after(:create) {|user| user.add_role :staff}
    end
  end
end
