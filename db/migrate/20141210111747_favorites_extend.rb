class FavoritesExtend < ActiveRecord::Migration
  def change
    change_table :favorites do |t|
      t.rename :favorable_id, :object_id
      t.rename :favorable_type, :object_type
      t.integer :creator_id
    end

    add_index :favorites, [:object_id, :object_type, :owner_id, :owner_type], unique: true, name: 'uniq_favorites_idx'
  end
end
