class CreateUserRecipes < ActiveRecord::Migration
  def change
    create_table :user_recipes do |t|
      t.references :user, index: true
      t.references :recipe, index: true
      t.integer :rating
      t.integer :like, :default => 0
      t.string :comment

      t.timestamps null: false
    end
    add_foreign_key :user_recipes, :users
    add_foreign_key :user_recipes, :recipes
  end
end
