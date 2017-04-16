# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :skill_category_record do
    skill_category { FactoryGirl.create :skill_category }
    association :skill_categorizable, factory: :candidate
  end

  trait :candidate_skill_category_record do
    association :skill_categorizable, factory: :candidate
  end

  trait :job_skill_category_record do
    association :skill_categorizable, factory: :job
  end
end
