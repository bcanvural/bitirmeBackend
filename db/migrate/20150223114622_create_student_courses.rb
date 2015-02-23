class CreateStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|
      t.references :course
      t.references :user

      t.timestamps
    end
  end
end
