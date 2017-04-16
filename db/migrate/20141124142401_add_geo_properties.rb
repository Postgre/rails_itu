class AddGeoProperties < ActiveRecord::Migration
  def change
    add_column :jobs, :latitude, :float
    add_column :jobs, :longitude, :float
    add_column :jobs, :location, :string
    add_index :jobs, [:latitude, :longitude]
    add_column :interviews, :latitude, :float
    add_column :interviews, :longitude, :float
    add_index :interviews, [:latitude, :longitude]
    add_column :candidates, :latitude, :float
    add_column :candidates, :longitude, :float
    add_column :candidates, :address, :string
    add_index :candidates, [:latitude, :longitude]
    add_column :companies, :latitude, :float
    add_column :companies, :longitude, :float
    add_column :companies, :address, :string
    add_index :companies, [:latitude, :longitude]
  end
end
