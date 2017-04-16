class RemoveTimeZonePreferenceFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :time_zone_preference
  end
end
