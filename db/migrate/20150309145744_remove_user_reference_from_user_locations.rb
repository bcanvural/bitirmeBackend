class RemoveUserReferenceFromUserLocations < ActiveRecord::Migration
  def change
    remove_reference :user_locations, :user_id
  end
end
