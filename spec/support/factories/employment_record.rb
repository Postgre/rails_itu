# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :employment_record do
    candidate
    company_name { Faker::Company.name }
    job_title { Faker::Job.title }
    description { Faker::Lorem.sentences(4) }
    start_date  { 18.years.ago }
    end_date    { Date.today - 1.year }
    city { Faker::Address.city }
    country_iso3 { Carmen::Country.all[rand(0..(Carmen::Country.all.size-1))].alpha_3_code }
  end
end
