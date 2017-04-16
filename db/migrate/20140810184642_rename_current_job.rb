class RenameCurrentJob < ActiveRecord::Migration
  def change
    rename_column :employment_records, :current_job, :is_current_job
  end
end
