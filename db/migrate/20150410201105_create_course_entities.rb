class CreateCourseEntities < ActiveRecord::Migration
  def change
    create_table :course_entities do |t|
      t.string :day
      t.references :course, index: true
      t.string :location
      t.timestamp :start_time
      t.timestamp :end_time

      t.timestamps
    end
  end
end
