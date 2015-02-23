class RemoveCourseidFromAttendance < ActiveRecord::Migration
  def change
    remove_column :attendance, :course_id
  end
end
