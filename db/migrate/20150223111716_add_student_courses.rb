class AddStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|
      t.references :course, index:true
      t.references :user, index:true
      t.timestamps
    end
  end
end
