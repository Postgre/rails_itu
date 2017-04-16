module SeedData
  class EducationRecordData
    class << self
      def create(candidate, limit=3)
        limit.times do
          e                 = ::EducationRecord.new
          e.candidate       = candidate
          e.city            = Faker::Address.city
          e.school          = "#{e.city} University"
          e.country_id      = Country.limit(20).sample.id
          e.start_year      = Random.rand(20.ago.year)
          e.end_year        = e.start_year + 4
          e.degree          = ['Phd',
                               'Master of Science',
                               'Master of Arts',
                               'Bachelor of Science',
                               'Bachelor of Arts'].sample
          e.field_of_study  = Faker::Lorem.words(3)
          e.description     = Faker::Lorem.sentence(5)
          e.is_verified     = [true, false].sample
          e.has_graduated   = [true, false].sample
          e.save
        end
      end
    end
  end
end
