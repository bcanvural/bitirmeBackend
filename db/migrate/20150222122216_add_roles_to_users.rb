class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instructor, :boolean
    add_column :users, :student, :boolean
  end
end
