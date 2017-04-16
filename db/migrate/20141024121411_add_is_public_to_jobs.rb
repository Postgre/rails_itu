class AddIsPublicToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_public, :boolean, null: false, default: true
  end
end
