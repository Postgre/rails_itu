class RenameStreetAddress2 < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.rename :street_address_2, :street_address2
    end
  end
end
