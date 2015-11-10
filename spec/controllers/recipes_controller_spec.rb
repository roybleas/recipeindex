require 'rails_helper'

RSpec.describe RecipesController, :type => :controller do

	describe "GET show" do
		before (:each) do
			@recipe = create(:recipe_with_issue)
		end
    it "returns http success" do
      get :show, id:@recipe
      expect(response).to have_http_status(:success)
    end
    it "assigns the requested recipe to @recipe" do
    	get :show, id:@recipe
    	expect(assigns(:recipe)).to eq @recipe
    end
    it "assigns the issue for the requested recipe" do
    	issue = create(:issue)
    	recipe = create(:recipe, issue_id: issue.id)
    	get :show, id:recipe
    	expect(assigns(:issue_with_desc)).to eq(issue)
    end
    it "assigns categories for the requested recipe" do
    	cattype = create(:categorytype, code: 'I')
			cat = create(:category, categorytype: cattype )
    	catrec = create(:category_recipe, category_id: cat.id, recipe_id: @recipe.id)
    	get :show, id:@recipe
    	expect(assigns(:categories)).to match_array(cat)
    end
    it "set the column height for single category" do
    	cattype = create(:categorytype, code: 'I')
			cat = create(:category, categorytype: cattype )
    	catrec = create(:category_recipe, category_id: cat.id, recipe_id: @recipe.id)
    	get :show, id:@recipe
    	expect(assigns(:columnheight)).to eq(1)
    end
    	
    it "assigns no user comments when not logged in" do
    	allow(controller).to receive_messages(:logged_in? => false)
    	get :show, id:@recipe
    	expect(assigns(:user_recipe)).to be_nil
    end
    context "user logged in" do
    	before(:each)  do
    		allow(controller).to receive_messages(:logged_in? => true)
    		@current_user = create(:user)
    		session[:user_id] = @current_user.id
    	end
    	
	    it "assigns user comments when logged in" do
	    	userrecipe = create(:user_recipe, user_id: @current_user.id, recipe_id: @recipe.id, comment: "test comment")
	    	get :show, id:@recipe
	    	expect(assigns(:user_recipe).comment).to eq("test comment")
	    end
	    it "assigns user rating when logged in" do
	    	userrecipe = create(:user_recipe, user_id: @current_user.id, recipe_id: @recipe.id, rating: 3)
	    	get :show, id:@recipe
	    	expect(assigns(:user_recipe).rating).to eq(3)
	    end
	    it "assigns user dislike when logged in" do
	    	userrecipe = create(:user_recipe, user_id: @current_user.id, recipe_id: @recipe.id, like: -1)
	    	get :show, id:@recipe
	    	expect(assigns(:user_recipe).like).to eq(-1)
	    end
	  end
  end
end
