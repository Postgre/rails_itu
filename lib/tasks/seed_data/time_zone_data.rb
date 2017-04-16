module SeedData
  class TimeZoneData
    class << self
      def load
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE time_zones")
        ActiveSupport::TimeZone.all.each do |time_zone|
          puts format('loading %s', time_zone.name)
          ::TimeZone.create!({name: time_zone.name})
        end
        nil
      end
    end
  end
end
