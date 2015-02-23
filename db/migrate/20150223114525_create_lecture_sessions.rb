class CreateLectureSessions < ActiveRecord::Migration
  def change
    create_table :lecture_sessions do |t|
      t.references :course
      t.references :user
      t.string :qrcode

      t.timestamps
    end
  end
end
