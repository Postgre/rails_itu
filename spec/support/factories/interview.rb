FactoryGirl.define do
  factory :interview do
    company
    job
    candidate { create :candidate }
    date { 2.days.from_now }
    sequence(:location) { Faker::Lorem.sentence(3) }
    details { Faker::Lorem.sentence(3) }

    trait :in_itu do
      company   { create :company, :itu }
      job       { create(:job, company: company) }
    end
  end
end
