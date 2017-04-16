class AddEmsCoursetermStudentIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :ems_courseterm_student_id, :integer
  end
end
