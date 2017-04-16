class ChangeCandidateScheduleAvailableToInt < ActiveRecord::Migration
  def change
    change_column :candidates, :schedule_available, :integer, default: 2
  end
end
