class CreateConstants < ActiveRecord::Migration
  def change
    create_table :constants do |t|
      t.date :termstartdate

      t.timestamps
    end
  end
end
