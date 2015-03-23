class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.float :loc_x
      t.float :loc_y

      t.timestamps
    end
  end
end
