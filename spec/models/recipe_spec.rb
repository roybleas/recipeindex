# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string
#  page       :integer
#  url        :string
#  issue_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Recipe, :type => :model do
	before :each do
 		@issue = Issue.new(title: "20", no: 30)
 	end
	
	it "is valid with title, page and url" do
		issue = @issue
		recipe = issue.recipes.new(title: "chilli beef on avocado" , page: 110, url: "http://www.taste.com.au/recipes/3600/chilli+beef+on+avocado")
		expect(recipe).to be_valid
	end
	  
	it "is invalid without a page" do
		issue = @issue
		recipe = issue.recipes.new(title: "bangers & mash with onion gravy" ,page: nil)
		recipe.valid?
  	expect(recipe.errors[:page]).to include("can't be blank")
  end
  
	it "is valid without a url" do
		issue = @issue
		recipe = issue.recipes.new(title: "banana bread" ,page: 91, url: nil)
		expect(recipe).to be_valid
	end
	
	it "is invalid without a title " do
		issue = @issue
		recipe = issue.recipes.new(title: nil,page: 101)
		recipe.valid?
  	expect(recipe.errors[:title]).to include("can't be blank")
  end
		
	
end
