class AddChangerIdToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :changer_id, :integer
  end
end
