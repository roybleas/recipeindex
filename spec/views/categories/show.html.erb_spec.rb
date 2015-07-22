require 'rails_helper'

RSpec.describe "categories/show.html.erb", :type => :view do
  
  before(:each) do
  	cattype = create(:categorytype, code: 'I')
  	@category = create(:category,  :categorytype => cattype )
  	@recipes = []
	end	
  
  context "view a category " do
  	it "displays the show template" do
  		render
  		expect(view).to render_template(:show)
  	end
  	it "displays a category name" do
  		render
  		expect(rendered).to match /#{@category.name}/ 
  	end
  end
  
  context "view category without recipes" do
  	it "displays no recipes available" do
  		render 
  		expect(rendered).to match /No recipes available/
  		assert_select 'p',"No recipes available."
  	end
	end
	
	context "recipes belonging to a category" do
		context "user not logged in" do
			it "displays a recipe" do
				issue = create(:issue, year: 1998)
				recipe = create(:recipe, issue_id: issue.id )
				catrec = create(:category_recipe, category_id: @category.id, recipe_id: recipe.id)
				@recipes = Recipe.by_category(@category)
				@catrec = [catrec]
				allow(view).to receive_messages(:logged_in? => false)
				render
				assert_select 'td', recipe.title
			end
		end
		context "user logged in" do
			before(:each) do
				@issue = create(:issue, year: 1999)
				@issue2 = create(:issue, year: 2000)
				recipe = create(:recipe, issue_id: @issue.id )
				catrec = create(:category_recipe, category_id: @category.id, recipe_id: recipe.id)
				@user = create(:user)
				@catrec = [catrec]				
			end
			
			it "displays a recipe from an issue user does not own" do
				user_issue = create(:user_issue, issue_id: @issue2.id, user_id: @user.id)
				@recipes = Recipe.by_category_and_user(@category,@user.id)
				allow(view).to receive_messages(:logged_in? => true)
				expect(render).to_not include("<span class=\"glyphicon glyphicon-ok\"></span>")
			end
			it "displays a recipe from an issue user does own" do
				user_issue = create(:user_issue, issue_id: @issue.id, user_id: @user.id)
				@recipes = Recipe.by_category_and_user(@category,@user.id)
				allow(view).to receive_messages(:logged_in? => true)
				expect(render).to include("<span class=\"glyphicon glyphicon-ok\"></span>")
			end
		end
	end
end
