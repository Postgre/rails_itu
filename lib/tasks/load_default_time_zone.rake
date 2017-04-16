namespace :default_time_zone do
  desc 'Load default time zone'
  task :load, [:file] => [:environment] do |_t, args|
    ActiveSupport::TimeZone.all.each do |time_zone|
      TimeZone.create!({name: time_zone.name})
    end
  end
end
