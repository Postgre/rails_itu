class RemoveSeekingWorkFromCandidates < ActiveRecord::Migration
  def change
    remove_column :candidates, :seeking_work
  end
end
