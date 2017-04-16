class AddIndexWithCreatorIdToFavorites < ActiveRecord::Migration
  def change
    remove_index :favorites, name: 'uniq_favorites_idx'
    add_index :favorites, [:subject_id, :subject_type, :owner_id, :owner_type, :creator_id], unique: true, name: 'uniq_favorites_idx'
  end
end
