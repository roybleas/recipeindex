require 'rails_helper'

RSpec.describe "issues/show.html.erb", :type => :view do
	
	context "with Publication,Issue " do
    before(:each) do
      assign(:pub, Publication.new(title: "Delicious"))
      @this_issue = Issue.create(no: 123, year: 2001)
   		assign(:issue,@this_issue)
   		assign(:issuedesc,Issuedescription.new(title: "April"))
   		assign(:previous_issuedescription, FactoryGirl.create(:issue_without_description, year: 2000))
   		assign(:next_issuedescription, FactoryGirl.create(:issue_without_description, year: 2002))
   		this_recipe = create(:recipe , page: 102, title: "Baked kumara with yoghurt dressing", issue_id: @this_issue.id)
   		assign(:recipes, [this_recipe])
   		@recipe = this_recipe
   		@user = create(:user)
   	end
	
	
	  it "displays a publication title" do
	    render
			expect(rendered).to match /Delicious/
	  end
	  it "displays an issue No " do
	  	render 
	  	expect(rendered).to match /123/
	  end
	  it "display an issue title" do
	  	assign(:issue,Issue.create(title: "OneTwoThree", year: 2001))
	  	render
	  	expect(rendered).to match /OneTwoThree/
	  end
	  it "displays an issue year " do
	  	render 
	  	expect(rendered).to match /2001/
	  end
	  it "displays an issue description title " do
	  	render 
	  	expect(rendered).to match /April/
	  end
	  it "displays a recipe " do
	  	render 
	  	expect(rendered).to match /102/
	  	expect(rendered).to match /Baked kumara/
	  end
	  it "displays a recipe with a link " do
	  	assign(:recipes, [  FactoryGirl.create(:recipe , page: 103, title: "Baked Alaska", url: "www.awebsite.com.au/recipe1.html", issue_id: @this_issue.id)])
	  	render 
	  	expect(rendered).to match /103/
	  	expect(rendered).to match /Baked Alaska/
	  	expect(rendered).to match /href="www.awebsite.com.au\/recipe1.html"/
	  end
	  context "logged on" do	  	
	  	before(:each) do
	  		session[:user_id] = @user.id
	  		#recipe = create(:recipe , page: 107, title: " Melon with lemongrass syrup", issue_id: @this_issue.id)
				@ur = create(:user_recipe, recipe_id: @recipe.id, user_id: @user.id, like: 1)
				@this_user_recipe = Recipe.by_issue_and_user_ratings(@this_issue.id , @user.id).all
			end
			
			it "displays a tick to show user owns it" do	  	
		  	ui = create(:user_issue, issue_id: @this_issue.id, user_id: @user.id)
		  	assign(:recipes, @this_user_recipe)
				render
				expect(rendered).to match /glyphicon-ok/
		  end
	  
		  it "displays a like icon when user recipe liked" do
		  	assign(:recipes, @this_user_recipe)
				render
				expect(rendered).to match /glyphicon-heart/
			end
		  it "displays a dislike icon when user recipe marked as dislike" do
		  	@ur.update(like: -1)
		  	this_user_recipe = Recipe.by_issue_and_user_ratings(@this_issue.id , @user.id).all
		  	assign(:recipes, this_user_recipe)
				render
				expect(rendered).to match /glyphicon-thumbs-down/
			end

		end
	end
end
