class AddUserReferenceToUserLocations < ActiveRecord::Migration
  def change
    add_reference :user_locations, :user, index: true
  end
end
