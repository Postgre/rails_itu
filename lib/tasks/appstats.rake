namespace :appstats do
  desc 'collect stats'
  task :collect => :environment do
    APP_STATS_COUNTERS.each_key do |type|
      APP_STATS_COUNTERS[type].each_key do |key|
        val = eval(APP_STATS_COUNTERS[type][key])
        Rails::Redis.hset "stats:#{type}", key, val
        Rails::Redis.hset "stats:#{type}", "#{key}/#{Time.current}", val
      end
    end
  end
end