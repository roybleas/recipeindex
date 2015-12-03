require 'rails_helper'
include UserrecipesHelper

RSpec.describe "recipes/show.html.erb", :type => :view do
  context "view a recipe " do
  	
  	before(:each) do
  		
  		issue = create(:issue_without_description, year: 2014)
  		@recipe = create(:recipe, issue_id: issue.id)
  		@issue_with_desc = create(:issue_with_descriptiontitle, year: 2014)
  		@cattype =  create(:categorytype, code: 'I')
 			@apple = create(:category, name: 'apple', :categorytype => @cattype )
			@categories = [@apple]
  		assign(:recipe, @recipe)
  		assign(:issue_with_desc, @issue_with_desc)
  		assign(:categories,@categories)
  		columns = 3
  		assign(:columnheight,( @categories.size / columns) + (@categories.size % columns == 0 ? 0 : 1))
  		 
  	end
  		
  	it "displays the show template" do
  		render
  		expect(view).to render_template(:show)
  	end
  	it "displays a recipe name" do
  		render
  		expect(rendered).to match /#{@recipe.title}/ 
  	end
  	it "display the issue where it is located" do
  		render
  		expect(rendered).to match /#{@issue_with_desc.year}/
  		expect(rendered).to match /#{@issue_with_desc.issuedescription_title}/
  		expect(rendered).to match /#{@issue_with_desc.publication_title}/
  	end
  	
  	it "does not display a category title when there are no categories " do
  		assign(:categories,[])
  		render 
  		expect(rendered).not_to match /Indexes/
  	end
  	it "does display a category title when there are categories " do
  		render 
  		expect(rendered).to match /Indexes/
  	end
  	it "displays the name of a category " do
  		render 
  		expect(rendered).to match /#{@apple.name}/
  	end
  	it "displays a list categories " do
  		zucchini = create(:category, name: 'zucchini' , :categorytype => @cattype)
			banana = create(:category, name: 'banana', :categorytype => @cattype )
			categories = [@apple,zucchini, banana]
			assign(:categories,categories)
			columns = 3
  		assign(:columnheight,( categories.size / columns) + (@categories.size % columns == 0 ? 0 : 1))
			
  		render 
  		expect(rendered).to match /#{@apple.name}/
  		expect(rendered).to match /#{banana.name}/
  		expect(rendered).to match /#{zucchini.name}/
  	end
  	it "has no link to user recipe whnen not logged in" do
  		render
  		expect(rendered).to_not match /Add notes/
  		expect(rendered).to_not match /Edit notes/
  	end
  	context "user logged in" do
  		before(:each) do
  			@user = create(:user)
  			allow(view).to receive_messages(:logged_in? => true)
  			allow(view).to receive_messages(:current_user => @user)
  		end
  				
  		it "shows the issue is owned by user" do
  			user_issue = create(:user_issue, issue_id: @issue_with_desc.id, user_id: @user.id)
  			render
  			expect(rendered).to include("<span class=\"glyphicon glyphicon-ok\"></span>")
  		end
  		it "shows the issue is not owned by user" do
  			render
  			expect(rendered).to_not include("<span class=\"glyphicon glyphicon-ok\"></span>")
  		end

			it "shows without user recipe ratings or likes" do
				render 
				expect(rendered).to_not include(star_glyph)
				expect(rendered).to_not include(like_glyph)
				expect(rendered).to_not include(dislike_glyph)
			end

			it "shows no rating with zero star rating" do
				userrecipe = create(:user_recipe, user_id: @user, recipe_id: @recipe)
				assign(:user_recipe, userrecipe)
				render 
				expect(rendered).to_not include(star_glyph)
			end
			
			it "shows a 1 star rating" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, rating: 1)
				assign(:user_recipe, user_recipe)
				render
				expect(rendered).to include("Personal Rating:")
				expect(rendered).to include("<span class=\"glyphicon glyphicon-star rating \"></span>")
			end
  		it "shows a 5 star rating" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, rating: 5)
				assign(:user_recipe, user_recipe)
				render
				star = "<span class=\"glyphicon glyphicon-star rating \"></span> "
				expect(rendered).to include(star * 5)
			end
			it "shows without being liked or disliked" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id)
				assign(:user_recipe, user_recipe)
				render 
				expect(rendered).to_not include(like_glyph)
				expect(rendered).to_not include(dislike_glyph)
			end
			it "shows a liked recipe" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, like: 1)
				assign(:user_recipe, user_recipe)
				render
				expect(rendered).to include("Personal Rating:")
				expect(rendered).to include(like_glyph)
				expect(rendered).to_not include(dislike_glyph)
			end
			it "shows a disliked recipe" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, like: -1)
				assign(:user_recipe, user_recipe)
				render
				expect(rendered).to include(dislike_glyph)
				expect(rendered).to_not include(like_glyph)
			end
			it "shows the last time a recipe was used" do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, lastused: Date.new(2014,10,23))
				assign(:user_recipe, user_recipe)
				render
				expect(rendered).to include("Last Used: 23 October 2014")
			end
			it "hides label when zero rating and impartial like " do
				user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id)
				render 
				expect(rendered).to_not include("Personal Rating:")
			end
			context "link to user recipe form" do
				it "can add new user recipe " do
					render
					expect(rendered).to match /Add Note/
				end
				it "can edit user recipe " do
					user_recipe = create(:user_recipe, recipe_id: @recipe, user_id: @user.id, like: 1)
					assign(:user_recipe, user_recipe)
					render
					expect(rendered).to match /Edit Note/
				end

			end
  	end
  end
end