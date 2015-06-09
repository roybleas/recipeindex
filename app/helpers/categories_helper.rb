module CategoriesHelper

	# compares the current range item with the selected letter ranges 
	# and returns an Active class when they do unless both empty
	def add_active_class_when_selected_letter(this_range,selected_range)
		
		if this_range == selected_range 
			return "class=active" unless selected_range.empty? 
		end
	end
	
	def format_recipe_title(recipe, cat_recipe_array, excludeOriginalCategoryId = -1)
		# convert keywords in the recipe title to links to their category pages
		# plus add links to the recipe page and recipe url if it exists
		
		# create a link to recipe page
		formated_recipe = link_to raw("<span class=\"glyphicon glyphicon-list-alt\"></span> "), recipe_path(recipe)
		
		#verify an array of category_recipes was extracted
		if cat_recipe_array.to_a.empty?
			formated_recipe.concat(recipe.title)
		else
			# extract the key words from the category_recipe array for the current recipe id
			keyword_list = cat_recipe_array.select{ | cat | cat.recipe_id == recipe.id && cat.category_id != excludeOriginalCategoryId}
			if keyword_list.empty?
				formated_recipe.concat(recipe.title)
			else
				recipe_words = recipe.title.split
				keyword_list.each do | keyword | 
					idx = recipe_words.index(keyword.keyword)
					if !idx.nil?
						recipe_words[idx] = link_to keyword.keyword, category_path(keyword.category_id)
					end
				end
				formated_recipe.concat(raw(recipe_words.join(" ")))
			end
		end
		
		unless recipe.url.nil?
			url = " <a href=\"#{recipe.url}\"> <span class=\"glyphicon glyphicon-globe\"></span> </a> "
			formated_recipe.concat(raw(url))
		end
		
		return formated_recipe
	end
	

	
end
