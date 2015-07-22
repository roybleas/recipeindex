require 'rails_helper'

RSpec.describe "recipes/show.html.erb", :type => :view do
  context "view a recipe " do
  	
  	before(:each) do
  		
  		issue = create(:issue_without_description)
  		@recipe = create(:recipe, issue_id: issue.id)
  		@issue_with_desc = create(:issue_with_descriptiontitle)
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
  		expect(rendered).not_to match /Categories/
  	end
  	it "does display a category title when there are categories " do
  		render 
  		expect(rendered).to match /Categories/
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


  	end
  			
  			
  			
  end
end