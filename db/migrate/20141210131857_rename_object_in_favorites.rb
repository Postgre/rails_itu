class RenameObjectInFavorites < ActiveRecord::Migration
  def change
    change_table :favorites do |t|
      t.rename :object_id, :subject_id
      t.rename :object_type, :subject_type
    end
  end
end
