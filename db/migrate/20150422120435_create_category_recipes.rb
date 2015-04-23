class CreateCategoryRecipes < ActiveRecord::Migration
  def change
    create_table :category_recipes do |t|
      t.references :category, index: true
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
