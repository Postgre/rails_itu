class RemoveTimeZoneFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :time_zone
  end
end
