require 'ffaker'
require 'csv'
module SeedData
  class UserData
    class << self
      def super_user
        u = default_user_params
        u.is_superuser = true
        u.save
        return u
      end

      def candidate(limit=1)
        limit.times do
          u =  default_user_params
          u.save
          return u if limit == 1
        end
      end

      def default_user_params
        u             = ::User.new
        u.prefix      = Faker::Name.prefix
        u.first_name  = Faker::Name.first_name
        u.last_name   = Faker::Name.last_name
        u.password    =  'p@ssword'
        u.password_confirmation = u.password
        u.email        = Faker::Internet.email
        u.phone_number = Faker::PhoneNumber.phone_number
        u.time_zone    = [1, 4, 5].sample
        u.itu_id       = SecureRandom.hex
        u
      end

      def create_beta_users
        file = "lib/tasks/seed_data/beta_users.csv"
        rows = CSV.read(file, headers: true)
        
        rows.each do |row|
          u = ::User.find_by_email(row['email'])

          unless u.present?
            u       = default_user_params
            u.email = row['email']
          end

          u.first_name = row['first_name'].titleize
          u.last_name  = row['last_name'].titleize
          u.password   = u.password_confirmation = 'p@ssword'
          u.save!
          u

          unless u.candidate.present?
            c      = ::Candidate.new
            c.user = u
            c.save!
          end

        end
      end

      def create_qa_users
        %w(lolga@itu.edu
        jwachira@itu.edu
        kranthi@itu.edu
        pgajanur@itu.edu
        vface@itu.edu
        ppokorny@itu.edu
        rirfan@itu.edu
        rvasiliy@itu.edu
        msergey@itu.edu
        rkulakhmetov@itu.edu
        fatlanov@itu.edu
        test01@itu.edu
        test02@itu.edu
        test03@itu.edu).each do |email|
          u       = default_user_params
          u.email = email
          u.save
          c      = ::Candidate.new
          c.user = u
          c.save
        end
      end
    end
  end
end
