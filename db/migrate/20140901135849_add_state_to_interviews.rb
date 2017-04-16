class AddStateToInterviews < ActiveRecord::Migration
  def change
    add_column :interviews, :state, :string, null: false
  end
end
