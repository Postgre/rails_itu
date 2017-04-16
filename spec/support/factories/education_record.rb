# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :education_record do
    candidate
    school { Faker::Company.name }
    start_year {Time.at(rand * Time.now.to_f).year}
    end_year   {start_year + 3}
    degree  { Faker::Lorem.sentence }
    field_of_study { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence(8) }
    city { Faker::Address.city }
    country_iso3 { Carmen::Country.all[rand(0..(Carmen::Country.all.size-1))].alpha_3_code }
    region { Faker::Address.city }
  end
end
