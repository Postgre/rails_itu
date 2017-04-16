class RenameColumnsWorkOptions < ActiveRecord::Migration
  def change
    add_column   :candidates, :availability, :integer, :default => 2
    remove_column :candidates, :schedule_available
    remove_column :candidates, :greencard_citizen
    remove_column :candidates, :restricted_work_status
    remove_column :candidates, :requires_sponsorship
  end
end
