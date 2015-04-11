class CreateAttendanceLists < ActiveRecord::Migration
  def change
    create_table :attendance_lists do |t|
      t.references :user, index: true
      t.references :course_entity, index: true
      t.timestamps
    end
  end
end
