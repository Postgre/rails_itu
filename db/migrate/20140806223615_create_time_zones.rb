class CreateTimeZones < ActiveRecord::Migration
  def change
    create_table :time_zones do |t|
      t.string  :name
      t.boolean :priority, default: false
      t.timestamps
    end
    Rake::Task['default_time_zone:load'].invoke
  end
end
