class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favorable, index: true, polymorphic: true
      t.references :owner, index: true, polymorphic: true

      t.timestamps
    end
  end
end
