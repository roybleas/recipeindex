class RemoveMealidFromRecipes < ActiveRecord::Migration
  def change
    remove_reference :recipes, :meal, index: true
  end
end
