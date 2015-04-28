class Dropmeals < ActiveRecord::Migration
  def up
    drop_table :meals
  end

  def down
    create_table :meals do |t|
      t.string :description
      t.integer :seq
      t.timestamps
    end
  end
end
