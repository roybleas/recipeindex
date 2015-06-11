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
  	it "displays a recipe name name" do
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
			#pear = create(:category, name: 'pears', :categorytype => cattype )
			#egg = create(:category, name: 'eggs', :categorytype => cattype )
  		render 
  		expect(rendered).to match /#{@apple.name}/
  		expect(rendered).to match /#{banana.name}/
  		expect(rendered).to match /#{zucchini.name}/
  	end
  end
end