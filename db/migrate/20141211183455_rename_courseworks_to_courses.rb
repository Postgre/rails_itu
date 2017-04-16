class RenameCourseworksToCourses < ActiveRecord::Migration
  def change
    rename_table :courseworks, :courses
  end
end
