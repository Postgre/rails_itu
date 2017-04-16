# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :candidate do
    user
    city { Faker::Address.city }
    region { Faker::Address.city }
    country_iso3 { Carmen::Country.all[rand(0..(Carmen::Country.all.size-1))].alpha_3_code }
    about { Faker::Lorem.sentences(4) }
    availability { [0].sample }

    trait :john do
      user { FactoryGirl.create :user, :john }
      after(:create) {|candidate| FactoryGirl.create(:skill_record, skillable: candidate)}
    end
  end
end
