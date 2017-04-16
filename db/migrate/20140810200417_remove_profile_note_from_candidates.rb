class RemoveProfileNoteFromCandidates < ActiveRecord::Migration
  def change
    remove_column :candidates, :profile_note
  end
end
