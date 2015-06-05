class CreateCategoryRecipes < ActiveRecord::Migration
  def change
    create_table :category_recipes do |t|
      t.string :keyword
      t.references :category, index: true
      t.references :recipe, index: true

      t.timestamps null: false
    end
    add_foreign_key :category_recipes, :categories
    add_foreign_key :category_recipes, :recipes
  end
end
