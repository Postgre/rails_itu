class AddVisibleToCourseworks < ActiveRecord::Migration
  def change
    add_column :courseworks, :visible, :boolean, default: true
  end
end
