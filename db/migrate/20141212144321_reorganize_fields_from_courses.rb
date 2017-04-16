class ReorganizeFieldsFromCourses < ActiveRecord::Migration
  def change
    change_column_null :courses, :visible, false
    rename_column :courses, :visible, :is_visible
  end
end
