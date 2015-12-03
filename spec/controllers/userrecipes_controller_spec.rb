require 'rails_helper'

RSpec.describe UserrecipesController, :type => :controller do
	fixtures :users

	before(:each) do
		@recipe = create(:recipe_with_issue)
		@user = users(:roy)
		session[:user_id] = @user.id
	end

  describe "GET #new" do
    it "returns http success" do
      get :new, :recipe_id => @recipe.id
      expect(response).to have_http_status(:success)
    end
    
    it "assigns a new userrecipe to @userrecipe" do
    	get :new, :recipe_id => @recipe.id
    	expect(assigns(:userrecipe)).to be_a_new(UserRecipe)
    	expect(assigns(:userrecipe).like).to eq(0) 
    	expect(assigns(:userrecipe).rating).to eq(0)
    	expect(assigns(:userrecipe).lastused).to be_nil
    end
    
    it "renders the new template" do
    	get :new, :recipe_id => @recipe.id
    	expect(response). to render_template :new
    end
    
  end

	describe "Post #create" do
				
		context "user logged in" do
			context "with valid attributes" do
				before(:each) do
					@userrecipe_attributes = {"user_recipe"=>{"like"=>"1", "rating"=>"2", "comment"=>"some stuff", "lastused(1i)"=>"2015", "lastused(2i)"=>"2", "lastused(3i)"=>"14"},  "recipe_id"=>@recipe.id}
				end
				it "saves the new userrecipe" do				
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(1)
				end
					
				it "redirects back to recipe" do
					post :create, @userrecipe_attributes
					expect(response).to redirect_to recipe_path(@recipe.id)
				end
			end		
			
			context "with invalid date attribute" do
				before(:each) do
					@userrecipe_attributes = {"user_recipe"=>{"like"=>"1", "rating"=>"2", "comment"=>"some stuff",
						"lastused(1i)"=>"2015", "lastused(2i)"=>"2", "lastused(3i)"=>"30"},  "recipe_id"=>@recipe.id}
				end
				it "rejects the new userrecipe" do				
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(0)
				end
					
				it "return to new" do
					post :create, @userrecipe_attributes
					expect(response).to render_template :new
				end
				
				it "accepts a valid month / day date field" do
					@userrecipe_attributes["user_recipe"]["lastused(2i)"] = "3"
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(1)
				end
				
				it "rejects a single blank date field" do
					@userrecipe_attributes["user_recipe"]["lastused(2i)"] = ""
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(0)
				end

				it "rejects multiple blank date fields" do
					params_date = {"lastused(1i)"=>"2012", "lastused(2i)"=>"", "lastused(3i)"=>""}
					params_date.each {|k,v| @userrecipe_attributes["user_recipe"][k] = v}
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(0)
				end				
			end
			
			context "with valid date attributes" do
				before(:each) do
					@userrecipe_attributes = {"user_recipe"=>{"like"=>"1", "rating"=>"2", "comment"=>"some stuff",
						},  "recipe_id"=>@recipe.id}
				end

				it "accepts all blank date fields" do
					params_date = {"lastused(1i)"=>"", "lastused(2i)"=>"", "lastused(3i)"=>""}
					params_date.each {|k,v| @userrecipe_attributes["user_recipe"][k] = v}
					expect{post :create, @userrecipe_attributes}.to change(UserRecipe, :count).by(1)
				end
			end
		end
		
		context "user not logged in" do
			it "redirects to logon screen" do
				session[:user_id] = nil
				userrecipe_attributes = {"user_recipe"=>{"like"=>"1", "rating"=>"2", "comment"=>"some stuff"},
						"userrecipe"=>{"lastused(1i)"=>"2015", "lastused(2i)"=>"2", "lastused(3i)"=>"14"},  "recipe_id"=>@recipe.id}
				post :create, userrecipe_attributes
				expect(response).to redirect_to login_path
			end
		end
	end
	
  describe "GET #edit" do
    it "returns http success" do
    	user_recipe = create(:user_recipe, recipe_id: @recipe.id)
      get :edit, id: user_recipe.id
      expect(response).to have_http_status(:success)
    end
    it "assigns the requested user_recipe to @user_recipe" do
			user_recipe = create(:user_recipe, recipe_id: @recipe.id)
			get :edit, id: user_recipe.id
			expect(assigns(:userrecipe)).to eq user_recipe
		end
		it "renders the :edit template" do
			user_recipe = create(:user_recipe, recipe_id: @recipe.id)
			get :edit, id: user_recipe
			expect(response).to render_template :edit
		end
  end

  describe "PATCH #update" do
  	before(:each) do
  		@userrecipe = create(:user_recipe, recipe_id: @recipe.id)
			@userrecipe_attributes = {"like"=>"1", "rating"=>"5", "comment"=>"A new comment.", "lastused(3i)"=>"", "lastused(2i)"=>"", "lastused(1i)"=>""}
  	end
    
    context "with vaild attributes" do
    	it "locates the correct user rescipe" do
    		patch :update, id: @userrecipe, user_recipe: @userrecipe_attributes
			  expect(assigns(:userrecipe)).to eq(@userrecipe)
			  expect(assigns(:recipe)).to eq(@recipe)
    	end
    	
    	it "updates the user recipe attributes" do
    		params_date = {"lastused(3i)"=>"2", "lastused(2i)"=>"1", "lastused(1i)"=>"2015"}
				params_date.each {|k,v| @userrecipe_attributes[k] = v}
    		patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
    		@userrecipe.reload
				expect(@userrecipe.like).to eq(1)
				expect(@userrecipe.rating).to eq(5)
				expect(@userrecipe.comment).to eq("A new comment.")
				expect(@userrecipe.lastused).to eq(Date.new(2015,1,2))
			end				
			
			it "redirects back to recipe" do
				patch :update, id: @userrecipe, user_recipe: @userrecipe_attributes
				expect(response).to redirect_to @recipe
			end
    end
    
    context "with invaild attribute" do
  		before(:each) do
  			@userrecipe_attributes["like"] = "-2"
  		end
  
  		it "does not update user recipe" do
  			patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
  			@userrecipe.reload
  			expect(@userrecipe.like).to_not eq(-2)
  			expect(@userrecipe.lastused).to be_nil
  		end
  	
  		it "stays at the edit page" do
  			patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
  			expect(response).to redirect_to edit_userrecipe_path
  		end		
		end  
		 		
		context "with dates" do
			
			it "updates with a blank date " do
				patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
    		@userrecipe.reload
    		expect(@userrecipe.lastused).to be_nil
			end
			
			it "updates blank with a valid date combination" do
    		params_date = {"lastused(3i)"=>"2", "lastused(2i)"=>"1", "lastused(1i)"=>"2015"}
				params_date.each {|k,v| @userrecipe_attributes[k] = v}
				patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
				@userrecipe.reload
				expect(@userrecipe.lastused).to eq(Date.new(2015,1,2))
			end
			
			it "rejects a previously blank date with an invalid date combination" do
    		params_date = {"lastused(3i)"=>"31", "lastused(2i)"=>"4", "lastused(1i)"=>"2015"}
				params_date.each {|k,v| @userrecipe_attributes[k] = v}
				patch :update, id: @userrecipe.id, user_recipe: @userrecipe_attributes	
				@userrecipe.reload
				expect(@userrecipe.lastused).to be_nil
			end
			
			context "user recipe with a date set" do
				before(:each) do
					@userrecipe2 = create(:user_recipe_with_date, recipe_id: @recipe.id)
				end					
				
				it "updates a valid date combination with blank" do
					userrecipe_attributes = {"like"=>"1", "rating"=>"5", "comment"=>"A new comment."}
	    		params_date =  {"day"=>"", "month"=>"", "year"=>""}
					patch :update, id: @userrecipe2.id, user_recipe: userrecipe_attributes, date: params_date
					@userrecipe2.reload
					expect(@userrecipe2.lastused).to be_nil
				end
				
				it "rejects a valid date that is updated with a single blank" do
	    		params_date =  {"day"=>"", "month"=>"11", "year"=>"2015"}
					patch :update, id: @userrecipe2.id, user_recipe: @userrecipe_attributes,date: params_date
					@userrecipe2.reload
					expect(@userrecipe2.lastused).to eq(Date.new(2015,11,23))
				end
			end
		end
		
		context "user not logged in" do
			it "re-directs to log on when attempting to update" do
				session[:user_id] = nil
				patch :update, id: @userrecipe, user_recipe: @userrecipe_attributes
				expect(response).to redirect_to login_path
			end
		end
	end
end
