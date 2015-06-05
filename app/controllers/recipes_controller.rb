class RecipesController < ApplicationController

	def show
		#save the parameter as an integer and fetch category 
  	recipe_id = params[:id].to_i
  	@recipe = Recipe.find(recipe_id)
  	
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
