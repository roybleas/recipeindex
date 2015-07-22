class RecipesController < ApplicationController
include Layoutcalculations
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
	
	def show
		#save the parameter as an integer and fetch category 
  	recipe_id = params[:id].to_i
  	@recipe = Recipe.find(recipe_id)
  	@issue_with_desc = Issue.and_description_title_for_recipe(recipe_id).first
  	@categories = Category.joins(:category_recipes).where("category_recipes.recipe_id = ?",recipe_id).order("categories.name asc")
  	@columnheight = column_height(@categories.count,1)
  	
	end
	
	private 
  
  def recipes_params
  		params.permit(:id)
  end
  def record_not_found
		flash[:danger] = "Record not found."
  	redirect_to root_url
  end
end
