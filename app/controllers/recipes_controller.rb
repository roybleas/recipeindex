class RecipesController < ApplicationController
include Layoutcalculations
	def show
		#save the parameter as an integer and fetch category 
  	recipe_id = params[:id].to_i
  	@recipe = Recipe.find(recipe_id)
  	@issue_with_desc = Issue.and_description_title_for_recipe(recipe_id).first
  	@categories = Category.joins(:category_recipes).where("category_recipes.recipe_id = ?",recipe_id)
  	@columnheight = column_height(@categories.count,1)
  	rescue ActiveRecord::RecordNotFound
	  	begin
	  		# When an unknown recipe requested go back 
	  		flash[:danger] = "Recipe not found"
	  		redirect_to :back
	  	
	  	rescue ActionController::RedirectBackError
	  		#if cannot go back goto root
  			flash[:danger] = "Recipe not found"
  			redirect_to root_url
  		end
	end
	
	private 
  
  def recipes_params
  		params.permit(:id)
  end
end
