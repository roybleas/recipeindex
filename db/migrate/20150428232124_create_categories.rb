class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :seq
      t.references :categorytype, index: true

      t.timestamps
    end
  end
end
