# bundle exec rake dev_helper:build_skills_for_candidates
namespace :dev_helper do

  desc "Add some skills to our test users"
  task build_skills_for_candidates: :environment do
    skills = Skill.all
    User.where(is_candidate: true).each do |u|
      skills.sample([1, 2, 3, 4, 5, 6].sample).each do |s|
        us = UserSkill.create user_id: u.id, skill_id: s.id,
                          tag: s.name,
                          level: %w(Beginner Intermediate Strong Expert Guru).sample,
                          years: [1, 2, 3, 4, 5, 6, 7, 8, 9].sample
      end
    end
  end

end
