
class UserrecipesController < ApplicationController
include Userlogin
before_action :logged_in_user, only: [:new, :edit, :create, :update]

  def new
  	@userrecipe = UserRecipe.new
  	@recipe = Recipe.find(params[:recipe_id])
  end
  
  def create
  	@recipe = Recipe.find(params[:recipe_id])
  	
  	@userrecipe = UserRecipe.new(user_recipe_params)
  	@userrecipe.recipe_id = @recipe.id
  	@userrecipe.user_id = current_user.id
  	
  	lastused_date = {:yr => user_recipe_params["lastused(1i)"], :mnth => user_recipe_params["lastused(2i)"], :dy => user_recipe_params["lastused(3i)"]} 
		
  	logger.info lastused_date.inspect
  	lastused = DateValidation.new(lastused_date)
  						 
  	
  	if not lastused.valid?
  		flash[:warning] = "Invalid date selected."
  		render 'new'
  	else
  		@userrecipe.lastused = lastused.date 
  	
	  	if @userrecipe.save
	  		flash[:success] = "Your rating for this recipe has been saved."
	  		redirect_to @recipe
	  	else
	  		render 'new'
	  	end
	  end
  end

  def edit
  	@userrecipe = UserRecipe.find(params[:id])
  	@recipe = Recipe.find(@userrecipe.recipe_id)
  end
  
 	def update
 		@userrecipe = UserRecipe.find(params[:id])
  	@recipe = Recipe.find(@userrecipe.recipe_id)
 		
 		logger.info  "Help!!!"
 		logger.info @userrecipe.lastused.nil?
 		logger.info @userrecipe.lastused
 		logger.info user_recipe_params.inspect
 		logger.info params[:date].inspect
 		logger.info user_recipe_params[:"lastused(1i)"].inspect
 		
		
  	
  	
  	
  	if @userrecipe.lastused.nil?					 
  		lastused_date = {:yr => user_recipe_params[:"lastused(1i)"], :mnth => user_recipe_params[:"lastused(2i)"], :dy => user_recipe_params[:"lastused(3i)"]} 
  	else
  		lastused_date = {:yr => params[:date][:"year"], :mnth => params[:date][:"month"], :dy => params[:date][:"day"]} 
  	end	

  	logger.info lastused_date.inspect
  	lastused = DateValidation.new(lastused_date)
  	logger.info lastused.inspect				 
  	
  	
  	if not lastused.valid?
  		flash[:warning] = "Invalid date selected."
  		#NB: render :edit generated /userrecipes/39 instead of /userrecipes/39/edit
  		redirect_to :action => :edit
  	else
  		@userrecipe.lastused = lastused.date 
  	
	  	if @userrecipe.update(user_recipe_params)
	  		flash[:success] = "Your rating for this recipe has been updated."
	  		redirect_to @recipe
	  	else
	  		redirect_to :action => :edit
	  	end
	  end

	  
	end
private 
  
  	def user_recipe_params
  		params.require(:user_recipe).permit(:like, :rating, :comment, :lastused, :date)
  	end
 	 
	class DateValidation
		def initialize(date_param)
			if date_param.values.reject{ |x| x == ""}.empty? || date_param.values.reject{ |x| x.nil? }.empty?
				# null date is valid
				@dte = nil
				@valid_date = true
			else
				date_param.each { |k,v| date_param[k] = v.to_i }
				if Date.valid_date?(date_param[:yr],date_param[:mnth],date_param[:dy])
					@dte = Date.new(date_param[:yr],date_param[:mnth],date_param[:dy])
					@valid_date = true
				else
					@dte = nil
					@valid_date = false
				end
			end
		end
		def valid?
			@valid_date
		end
		def date
			@dte
		end
  end
end
