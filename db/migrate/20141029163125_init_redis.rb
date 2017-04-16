class InitRedis < ActiveRecord::Migration
  def change
    say_with_time 'redis sets population' do
      SkillRecord.find_each do |record|
        record.add_to_redis
      end
    end
  end
end
