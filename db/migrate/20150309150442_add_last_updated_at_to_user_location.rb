class AddLastUpdatedAtToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :last_updated_at, :timestamp
  end
end
