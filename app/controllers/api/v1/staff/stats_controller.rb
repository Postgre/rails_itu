module API
  module V1
    module Staff
      class StatsController < ApiController
        def index
          authorize :user, :stats?

          types = %w(companies candidates)

          stats = types.map do |type|
            {
                type => Rails::Redis.hkeys("stats:#{type}").delete_if{|key| key.include? '/'}
                            .sort_by{|key| APP_STATS_COUNTERS[type.to_sym].keys.index(key) }
                            .map{|key| {code: key,
                                        name: I18n.t("stats.#{type}.keys.#{key}"),
                                        value: Rails::Redis.hget("stats:#{type}", key)}}
            }
          end
          render json: stats
        end
      end
    end
  end
end
