class AddCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :instructor_name
      t.timestamps
    end
  end
end
