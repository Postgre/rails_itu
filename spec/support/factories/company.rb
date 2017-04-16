FactoryGirl.define do
  factory :company do
    industry { create :industry }
    country_iso3 { Carmen::Country.all[rand(0..(Carmen::Country.all.size-1))].alpha_3_code }
    city { Faker::Lorem.word }
    postal_code { Faker::Lorem.word }
    name { Faker::Company.name }
    website { Faker::Internet.domain_name }
    about_us { Faker::Lorem.sentence(3) }
    street_address { Faker::Lorem.sentence(3) }
    users {|u| [u.association(:user)]}

    trait :itu do
      name 'ITU'
      website 'http://itu.edu/'
      users { [create(:user, :john)] }

      after(:create) {|company| company.users.where(first_name: 'John').first.add_role :representative, company}
    end
  end
end
