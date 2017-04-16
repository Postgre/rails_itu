class RemoveEducationRecordIdFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :education_record_id
  end
end
