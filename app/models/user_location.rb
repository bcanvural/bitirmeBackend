class UserLocation < ActiveRecord::Base

  def update_last_viewed_at (timestamp)
    self.last_updated_at = timestamp
    self.save
  end
end
