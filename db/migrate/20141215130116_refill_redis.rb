class RefillRedis < ActiveRecord::Migration
  def change
    say_with_time 'filling redis' do
      SkillRecord.find_each do |record|
        record.add_to_redis
      end
    end
  end
end
