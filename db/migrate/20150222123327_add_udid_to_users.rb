class AddUdidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :udid, :string
  end
end
