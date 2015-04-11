class RemoveTables < ActiveRecord::Migration
  def change
    drop_table :user_locations
    drop_table :photos
    drop_table :lecture_sessions
    drop_table :classrooms
    drop_table :attendances
  end
end
