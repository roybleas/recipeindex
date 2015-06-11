module RecipesHelper

	def capitalise_first_letter(recipe)
		recipe[0] = recipe[0].upcase unless recipe.nil? || recipe.empty?
		return recipe
	end
	
	def concat_issue_description_with_year(issue_description, issue_year)
		return (issue_description + "&nbsp;" + issue_year.to_s).html_safe
	end
end