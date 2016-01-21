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
  	if logged_in?
  		@user_recipe = UserRecipe.where("user_id = ? and recipe_id = ?",current_user.id,recipe_id).first
  	end
	end
	
	def bymonth
		if logged_in?
			@month_index = params[:id].to_i			
			@previous_month_index = @month_index == 1 ? 12 : @month_index - 1
			@next_month_index = @month_index == 12 ? 1 : @month_index + 1
			#Month is set for the session
			session[:user_favourite_month] = @month_index
			@recipes = Recipe.favourites_by_month_and_user(@month_index,current_user.id)
			@category_id = -1 
			@catrec = CategoryRecipe.distinct.joins(:user_recipes, :issuemonths).by_liked_by_month(@month_index,current_user.id).all.to_a

		else
			redirect_to login_url
		end
	end
	
	def selectmonth
		@month_index = params[:id].to_i			
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
