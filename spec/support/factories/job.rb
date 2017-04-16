FactoryGirl.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Lorem.sentence(3) }
    company
    state 'published'
    work_type { Job::WORK_TYPE.map{|e| e[:value]}.sample }
    schedule { Job::SCHEDULE.map{|e| e[:value]}.sample }
    start_date {Date.today + 15}
    years {[1,2,3].sample}
    is_public true
    created_at { Time.current }
    published_at { Time.current }
    last_state_change_at { Time.current }
  end

  trait :closed do
    state 'closed'
  end

  trait :with_skills do
    after(:create) {|job| FactoryGirl.create(:skill_record, skillable:job)}
  end
end
