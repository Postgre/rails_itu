require 'ffaker'
module SeedData
  class EmploymentRecordData
    class << self
      def create(candidate, limit=3)
        limit.times do
          e               = ::EmploymentRecord.new
          e.company_name  = Faker::Company.name
          e.candidate_id   = candidate.id
          e.job_title   = Faker::Company.catch_phrase
          e.description = Faker::Lorem.paragraph
          e.start_date  = Random.rand(20.year).ago
          e.end_date    = Random.rand(20.year).ago
          e.city        = Faker::Address.city
          e.country_id  = Country.limit(20).sample.id
          e.save!
        end
      end
    end
  end
end
