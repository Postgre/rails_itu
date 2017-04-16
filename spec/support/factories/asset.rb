# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do

  factory :asset do
    attachment_file_name 'avatar.jpg'
    attachment_content_type 'image/jpeg'
    attachment_file_size 4566
  end
  
  
  trait :user_avatar do
    association :attachable, factory: :user    
  end
  
end
