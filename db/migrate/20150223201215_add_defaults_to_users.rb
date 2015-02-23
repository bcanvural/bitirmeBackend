class AddDefaultsToUsers < ActiveRecord::Migration
  def change
    change_column :users, :student, :boolean, :default => true
    change_column :users, :instructor, :boolean, :default => false
  end
end
