class AddIsVisibleToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :is_visible, :boolean, default: true
  end
end
