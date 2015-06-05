class CategoriesController < ApplicationController
	def byletter
	
		@letter_ranges = letter_ranges
		
		#convert incoming parameter to downcase before seaching ranges for a match 
		# there should only be one match so get first item from array
		letter = params[:letter].downcase
  	@letters = @letter_ranges.select { |x| letter >= x[0] and letter <= x[1]}.first 
  	
  	#create default if nothing matched
  	@letters = @letter_ranges[0] if @letters.nil?
        
    # fetch categories to display
    @categories = Category.by_letter_range(@letters).joins(:categorytype).merge(Categorytype.by_list).all
    # column height is the number of categories to show in each of the 3 columns
    @columnheight = column_height(@categories.count)
    	
    render 'index'
  end
	
	def index
		@letter_ranges = letter_ranges
		#set default as the first range
		@letters = @letter_ranges[0]
		# fetch categories to display
		@categories = Category.by_letter_range(@letters).joins(:categorytype).merge(Categorytype.by_list).all
		# column height is the number of categories to show in each of the 3 columns
		@columnheight = column_height(@categories.count)
	end

  def show
  	#save the parameter as an integer and fetch category 
  	category_id = params[:id].to_i
  	@category = Category.find(category_id)
  	
  	#look up all the recipes associated with this category and their keyword links
  	@recipes = Recipe.select('recipes.* , publications.title as pub, issuedescriptions.title as desc , issues.year as year').joins(:categories).joins(issue: { issuedescription: :publication}).where('categories.id = ?',@category.id).order(title: :asc).all 	
  	@catrec = CategoryRecipe.keywords_list_by_category(category_id).all.to_a
  	
  rescue ActiveRecord::RecordNotFound
  	# When an unknown category requested go back to index
  	flash[:danger] = "Category not found"
  	redirect_to action: :index
  end
  
  private 
  
  def categories_params
  		params.permit(:letter)
  end
  	
  def letter_ranges
		# this array would be better if configurable but do not expect new categories
		# to affect split much
		return [%w[a b], %w[c d],%w[e m],%w[n p], %w[q z]]
  
  end
  
  def column_height(size)
  	# divides the number of categories by 3 and works out a rounding margin
  	if size == 0
  		return 0
  	else
    	return ( size / 3) + (size % 3 == 0 ? 0 : 1)
    end
   end
end
