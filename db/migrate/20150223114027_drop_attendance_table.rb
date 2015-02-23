class DropAttendanceTable < ActiveRecord::Migration
  def change
    drop_table :attendance
    drop_table :courses
    drop_table :lecture_session
    drop_table :student_courses
  end
end
