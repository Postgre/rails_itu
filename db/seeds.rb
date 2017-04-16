require 'ffaker'
#General Data
SeedData::CountryData.load
SeedData::TimeZoneData.load
SeedData::SkillCategoryData.load
SeedData::UserData.create_qa_users
SeedData::CandidateData.finalized_candidate_profiles(20)
