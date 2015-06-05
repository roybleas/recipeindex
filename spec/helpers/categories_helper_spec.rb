require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CategoriesHelper. For example:
#
# describe CategoriesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CategoriesHelper, :type => :helper do
  describe "add_active_class_when_selected_letter" do
    it " returns nil when selected range array does not match current range array" do 
      selected_range = %w[a b]
      current_range = %w[c d]
      expect(helper.add_active_class_when_selected_letter(current_range,selected_range)). to be_nil
    end
    
    it "returns class=Active when selected and current range array match" do
      selected_range = %w[e f]
      current_range = %w[e f]
      expect(helper.add_active_class_when_selected_letter(current_range,selected_range)). to eq("class=active")
    end
    
    it "returns nil when selected and current range array are empty" do
      selected_range = []
      current_range = []
      expect(helper.add_active_class_when_selected_letter(current_range,selected_range)). to be_nil
    end 
  end
  
  describe "format_recipe_title" do
    before(:each) do
      @this_issue = create(:issue_without_description, year: 2001)
    end
    
    # Reminder of parameters 
    # format_recipe_title(recipe, cat_recipe_array, excludeOriginalCategoryId = -1)
    
    it "returns the recipe with a link to recipe the url when no matching categories_recipes" do
      recipe = FactoryGirl.create(:recipe , issue_id: @this_issue.id)
      formatted_recipe = "<a href=\"/recipes/#{recipe.id}\"><span class=\"glyphicon glyphicon-list-alt\"></span> </a>#{recipe.title}"
      cat_recipe_array = []
      expect(helper.format_recipe_title(recipe,cat_recipe_array)).to eq(formatted_recipe)
    end
    
    it "returns the recipe with a link to other website url" do
      this_url = "www.anywebsite.com/recipe/12345"
      recipe = FactoryGirl.create(:recipe , issue_id: @this_issue.id, url: this_url)
      formatted_recipe = "<a href=\"/recipes/#{recipe.id}\"><span class=\"glyphicon glyphicon-list-alt\"></span> </a>#{recipe.title} "
      formatted_recipe.concat("<a href=\"#{this_url}\"> <span class=\"glyphicon glyphicon-globe\"></span> </a> ")
      cat_recipe_array = []
      expect(helper.format_recipe_title(recipe,cat_recipe_array)).to eq(formatted_recipe)
    end
    
    context "with category_recipes" do
	    before(:each) do
	    	@this_keyword = "TestKeyword"
	      @recipe_title_format = "A recipe includes %{keyword} in it."
	      recipe_title = sprintf(@recipe_title_format,{keyword: @this_keyword})
	
	      @cattype = create(:categorytype, name: "Ingredient", code: "I")
	      @category = create(:category, categorytype_id: @cattype.id)
	      @recipe = FactoryGirl.create(:recipe ,title: recipe_title, issue_id: @this_issue.id)
	      @catrec = create(:category_recipe, keyword: @this_keyword, recipe_id: @recipe.id, category_id: @category.id)
	      
	    end
	    	
	    it "returns the recipe with a link to recipe list for matching category" do      
	      
	      linked_keyword = "<a href=\"/categories/#{@category.id}\">#{@this_keyword}</a>"
	      recipe_title = sprintf(@recipe_title_format,{keyword: linked_keyword})
	      
	      formatted_recipe = sprintf(%Q(<a href="/recipes/%{recipe_id}">) +
	        %Q(<span class="glyphicon glyphicon-list-alt"></span> </a>%{recipe_title}) ,
	        {recipe_id: @recipe.id, recipe_title: recipe_title})
	      
	      cat_recipe_array = [@catrec]
	      expect(helper.format_recipe_title(@recipe,cat_recipe_array)).to eq(formatted_recipe)
	      
	    end
	    
	    it "returns the recipe without a link as matching category passed to function" do
	           
	      formatted_recipe = sprintf(%Q(<a href="/recipes/%{recipe_id}">) +
	        %Q(<span class="glyphicon glyphicon-list-alt"></span> </a>%{recipe_title}) ,
	        {recipe_id: @recipe.id, recipe_title: @recipe.title})
	      
	      cat_recipe_array = [@catrec]
	      
	      expect(helper.format_recipe_title(@recipe,cat_recipe_array,@category.id)).to eq(formatted_recipe)
	      
	    end
	    
	    context "with multiple category_recipes" do
	    	before(:each) do
	    		@second_keyword = "Keyword_2"
		      @category2 = create(:category, categorytype_id: @cattype.id)
		      @catrec2 = create(:category_recipe, keyword: @second_keyword, recipe_id: @recipe.id, category_id: @category2.id)
		      @recipe.title = sprintf(@recipe_title_format,{keyword: [@this_keyword, @second_keyword].join(" ")})

	    	end
	    
		    it "returns the recipe with a 2nd keyword link to recipe list for matching category" do      
		      	      
		      linked_keywords = ["<a href=\"/categories/#{@category.id}\">#{@this_keyword}</a>"]
		      linked_keywords << "<a href=\"/categories/#{@category2.id}\">#{@second_keyword}</a>"
		      
		      recipe_title = sprintf(@recipe_title_format,{keyword: linked_keywords.join(" ")})
		      
		      formatted_recipe = sprintf(%Q(<a href="/recipes/%{recipe_id}">) +
		        %Q(<span class="glyphicon glyphicon-list-alt"></span> </a>%{recipe_title}) ,
		        {recipe_id: @recipe.id, recipe_title: recipe_title})
		      
		      cat_recipe_array = [@catrec2, @catrec]
		      expect(helper.format_recipe_title(@recipe,cat_recipe_array)).to eq(formatted_recipe)
		      
		    end
		    
		    it "returns the recipe with a 2nd keyword link and without first matching category" do      
		      	      
		      linked_keywords = [@this_keyword]
		      linked_keywords << "<a href=\"/categories/#{@category2.id}\">#{@second_keyword}</a>"
		      
		      recipe_title = sprintf(@recipe_title_format,{keyword: linked_keywords.join(" ")})
		      
		      formatted_recipe = sprintf(%Q(<a href="/recipes/%{recipe_id}">) +
		        %Q(<span class="glyphicon glyphicon-list-alt"></span> </a>%{recipe_title}) ,
		        {recipe_id: @recipe.id, recipe_title: recipe_title})
		      
		      cat_recipe_array = [@catrec2, @catrec]
		      expect(helper.format_recipe_title(@recipe,cat_recipe_array, @category.id)).to eq(formatted_recipe)
		      
		    end
		  end
		end
  end
  
end
