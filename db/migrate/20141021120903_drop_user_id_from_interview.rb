class DropUserIdFromInterview < ActiveRecord::Migration
  def change
    remove_column :interviews, :user_id
  end
end
