class AddAttendsTable < ActiveRecord::Migration
  def change
    create_table :attendance do |t|
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
