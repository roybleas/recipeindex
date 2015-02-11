class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :page
      t.string :url
      t.references :issue, index: true
      t.references :meal, index: true

      t.timestamps
    end
  end
end
