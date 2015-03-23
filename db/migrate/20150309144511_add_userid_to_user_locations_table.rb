class AddUseridToUserLocationsTable < ActiveRecord::Migration
  def change
    add_reference :user_locations, :user_id, index:true
  end
end
