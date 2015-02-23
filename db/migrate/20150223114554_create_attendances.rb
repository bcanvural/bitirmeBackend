class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.references :lecture_session
      t.references :user

      t.timestamps
    end
  end
end
