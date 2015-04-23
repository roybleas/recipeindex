class CreateIngredientRecipes < ActiveRecord::Migration
  def change
    create_table :ingredient_recipes do |t|
      t.references :ingredient, index: true
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
