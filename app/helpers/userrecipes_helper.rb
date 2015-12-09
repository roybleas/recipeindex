module UserrecipesHelper

	def recipe_has_user_rating(user_recipe)
		rating = ""
		if logged_in?
			if !user_recipe.nil?
				rating = rating + like_glyph if user_recipe.like == 1
				rating = rating + dislike_glyph if user_recipe.like == -1
				rating = rating + star_glyph * user_recipe.rating
			end
		end
		return rating.html_safe
	end
	
	def get_user_like_symbol(recipe)
		like_symbol = ""
		if logged_in?
			like_symbol = like_glyph if recipe.user_recipes_like == 1
			like_symbol = dislike_glyph if recipe.user_recipes_like == -1
		end
		return like_symbol
	end

	def get_user_rating_symbol(recipe)
		rating = ""
		if logged_in?
			rating = rating + star_glyph * recipe.user_recipes_rating unless recipe.user_recipes_rating.nil?
		end
		return rating
	end
		
	def like_glyph
		 "<span class=\"glyphicon glyphicon-heart rating like \"></span>"
	end
	def dislike_glyph
		"<span class=\"glyphicon glyphicon-thumbs-down rating like \"></span>"
	end
	def star_glyph
		"<span class=\"glyphicon glyphicon-star rating \"></span> "
	end
	
	
end
