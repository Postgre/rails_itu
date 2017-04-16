# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :skill_record do
    skill { FactoryGirl.create :skill }
    level {[0,1,2,3,4].sample}
    years_of_experience {1}
  end

  trait :candidate_skill_record do
    association :skillable, factory: :candidate
  end

  trait :job_skill_record do
    association :skillable, factory: :job
  end
end
