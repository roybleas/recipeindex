require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RecipesHelper. For example:
#
# describe RecipesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RecipesHelper, :type => :helper do
  
  describe "capitalise_first_letter" do
  	it "converst the first character to upper case" do
  		recipe = "word"
  		expect(helper.capitalise_first_letter(recipe)).to eq("Word")
  	end
  	
  	it "keeps the first character as upper case" do
  		recipe = "Word"
  		expect(helper.capitalise_first_letter(recipe)).to eq("Word")
  	end
  	
  	it "only converts the first character to upper case" do
  		recipe = "word and Another word "
  		expect(helper.capitalise_first_letter(recipe)).to eq("Word and Another word ")
  	end
  	
  	it "can change a single character parameter" do
  		recipe = "a"
  		expect(helper.capitalise_first_letter(recipe)).to eq("A")
  	end
	
  	it "does not fail with an empty string parameter" do
  		recipe = ""
  		expect(helper.capitalise_first_letter(recipe)).to eq("")
  	end
  	
  	it "it does not fail with a nil parameter" do
  		recipe = nil
  		expect(helper.capitalise_first_letter(recipe)).to be_nil
  	end

  	it "it does not change the original parameter" do
  		recipe = "word"
  		expect(recipe).to eq("word")
  	end
	end
	
	describe "concat_issue_description_with_year(issue_description, issue_year)" do
		it "combines the 2 parameters with a non breaking space" do
			issue_description = "ABC"
			issue_year = 1234
			expect(helper.concat_issue_description_with_year(issue_description, issue_year)).to eq("ABC&nbsp;1234")
		end
	end
end
