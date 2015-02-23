class AddLectureSessionToAttendance < ActiveRecord::Migration
  def change
    add_reference :attendance, :lecture_session, index: true
  end
end
