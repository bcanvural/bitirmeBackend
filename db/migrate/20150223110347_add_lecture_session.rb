class AddLectureSession < ActiveRecord::Migration
  def change
    create_table :lecture_session do |t|
      t.references :course, index: true
      t.references :user, index:true
      t.string :qrcode
      t.timestamps
    end
  end
end

