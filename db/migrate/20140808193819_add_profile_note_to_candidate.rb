class AddProfileNoteToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :profile_note, :text
    add_column :candidates, :city, :string
    add_column :candidates, :country_id, :integer
    add_index :candidates, :country_id
  end
end
