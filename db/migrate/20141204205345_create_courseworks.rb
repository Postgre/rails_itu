class CreateCourseworks < ActiveRecord::Migration
  def change
    create_table :courseworks do |t|
      t.references :candidate, index: true
      t.references :education_record, index: true
      t.string :title
      t.string :department
      t.string :professor
      t.text :description
      t.string :semester

      t.timestamps
    end
  end
end
