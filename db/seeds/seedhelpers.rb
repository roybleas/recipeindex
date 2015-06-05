require 'csv'

class IssuedescriptionsGenerator
	#class to generate a row for each month linked to issue description
	def initialize(pub)	
		# store publication  
		@pub = pub
		# create a combined December - January title
		@decjan = "#{Date::MONTHNAMES[12].slice(0..2)}-#{Date::MONTHNAMES[1].slice(0..2)}"
	end
	
	def gen_monthly(excludeJan = true)
		#Create monthly issue description records
		
		if excludeJan then
			# skip January and set range from Feb to November
			month_start = 2
			month_end = -2
			
		else
			# include all months from Jan to Dec set range form 1 to last
			month_start = 1
			month_end = -1
		end
		
		#set sequence number so select in month order
		seqidx = -1
		
		#get months Feb to Nov and insert into DB
 		Date::MONTHNAMES.slice(month_start..month_end).each do |m|
			seqidx += 1
			@pub.issuedescriptions.create(title: m.slice(0..2),
				full_title: m,
				seq: seqidx)
		end
		
		seqidx += 1
		
		add_decjan_combination(excludeJan, seqidx)		

		add_issuemonths( excludeJan, seqidx)		
		
	end
	
	def gen_bimonthly(excludeJan = true)
		#Create bi-Monthly issue description records
		
		if excludeJan then
			# skip January and set range from Feb to November
			month_start = 2
			month_end = 11
		else
			# include all months from Jan to Dec set range from 1 to last
			month_start = 1
			month_end = 12
		end
		
		seqidx = -1
		(month_start..month_end).step(2).each { |m|
			seqidx += 1
			@pub.issuedescriptions.create(title: "#{Date::MONTHNAMES[m].slice(0..2)}-#{Date::MONTHNAMES[m + 1].slice(0..2)}",
				full_title: "#{Date::MONTHNAMES[m]}-#{Date::MONTHNAMES[m + 1]}",
				seq: seqidx)
		}
		
		seqidx += 1
		
		add_decjan_combination(excludeJan, seqidx)
		
		#find a list of all months
		desc = @pub.issuedescriptions.order('seq')
		
		desc.each do |d| 
			d.full_title.split("-").each { |m| 
				d.issuemonths.create(monthindex: Date::MONTHNAMES.index(m) ) unless !Date::MONTHNAMES.include?(m) }
		end
		
		add_issuemonths(excludeJan, seqidx)		
	end
	
	private
	
	def add_decjan_combination(excludeJan, seqidx)
		#if January is excluded then add a December/January combined record
		if excludeJan then
			# add Dec/Jan combination	
			@pub.issuedescriptions.create( title: @decjan ,
				full_title: "#{Date::MONTHNAMES[12]}-#{Date::MONTHNAMES[1]}",
				seq: seqidx)				
		end
	end
	
	def add_issuemonths( excludeJan, seqidx)
		# Create a record for each month of the year linked to its appropriate issue description
		# seqidx is the last sequence number addded plus one
	
		#find a list of all the standard months for publication ie without last month if January excluded
		desc = @pub.issuedescriptions.where("seq < #{seqidx}").order('seq')
		
		#add IssueMonth record with a month index for each Month
		desc.each { |d| d.issuemonths.create(monthindex: Date::MONTHNAMES.index(d.full_title) ) unless !Date::MONTHNAMES.include?(d.full_title) }
		
		if excludeJan then
			# add 2 Dec/Jan combination records
			descDec = @pub.issuedescriptions.find_by_title(@decjan)
			# Add rows for December and January
			[12,1].each do |m|
				descDec.issuemonths.create(monthindex: m ) 
			end
		end
	end
end

class IssueyearGenerator
	#class to generate a row for each issue linked to an issue description
	def initialize(pub, yr)	
		# store publication  
		@pub = pub
		# store the year of publication
		@yr = yr
	end
	
	def gen_issues_by_number(issue_number)
		# issue_number the number of the first issue for the year
		# create an issue for each issue description with an incrementing issue number and passed year
		issuesdescs = @pub.issuedescriptions.order(seq: :asc).all
		issuesdescs.each do |desc|
			desc.issues.create!(year: @yr, no: issue_number)
			issue_number += 1
		end
	end
end

class RecipeImporter
	#class to load recipes from extract file
	def initialize(pub,yr,mag_title)
		# store publication  
		@pub = pub
		# store the year of publication
		@yr = yr
		# or the issuenumber range
		@issueNumRange = yr
		# store the short name used in the extract file
		@mag_title = mag_title
		#type recipe records to be imported 
		@fileType = nil
	end
	
	def load_recipes_by_year
		
		filename = "#{@mag_title}_#{@yr}_idx_recipes.csv"
		fileInput = Rails.root.join('db','seeds','dbloadfiles',filename)
		
		if validFileHeader?(fileInput,filename)
							
			# Fetch all the issues for the year for the passed publication
			is_descs = @pub.issuedescriptions.select(:title).eager_load(:issues).where('issues.year = ?',@yr).order(:title).all
			
			# Header : 
			#	type		- content of the row
			# action	- type of action to the database	
			# issue		- the issue for the year where the recipe is found
			# page		- the page in the issue where the recipe is found
			# recipe	- the recipe title
			CSV.foreach(fileInput, {col_sep: "\t", headers: :true}) do |row|
				case row["type"]
				when "H"
					# header row checked above so ignore
				when "R"
						#recipe
						case row["action"]
							when "c"
								#create record 
								
								# The delicious December issue is combined with January
								# So a quick fix to convert to double issue
								this_issue = row["issue"].gsub("Dec","Dec-Jan")
								
								issue = find_issue(is_descs,this_issue)
								if !issue.nil?
									issue.recipes.create(title: row["recipe"], page: row["page"])
								else
									puts "Issue #{row['issue']} not found"
								end
							else
								puts "Unknown action record #{row['action']}"
						end
				else
						puts "Unknown type #{row['recipe']}"
				
				end
			end			
		end
	end

	def load_recipes_by_issue
		
		filename = "#{@mag_title}_#{@yr}_idx_recipes.csv"
		fileInput = Rails.root.join('db','seeds','dbloadfiles',filename)
		
		if validFileHeader?(fileInput,filename)
							
				# Fetch all the issues for the year for the passed publication
				is_descs = @pub.issuedescriptions.select(:title).eager_load(:issues).where('issues.year = ?',@yr).order(:title).all
				
				# Header : 
				#	type		- content of the row
				# action	- type of action to the database	
				# issue		- the issue for the year where the recipe is found
				# page		- the page in the issue where the recipe is found
				# recipe	- the recipe title
				
			current_issue_number = 0
			current_issue = nil
				
			CSV.foreach(fileInput, {col_sep: "\t", headers: :true}) do |row|
				
				case row["type"]
				when "H"
					# header row checked above so ignore
				when "R"
					#recipe
					case row["action"]
					when "c"
						#create record 
						if current_issue_number != row['issue'].to_i
							#if there is a change of issue look up the new from the database
							current_issue_number = row['issue'].to_i
							current_issue =  @pub.issues.find_by(no: current_issue_number)
							if current_issue.nil?
								puts "Issue #{row['issue']} not found"
							end
						end
									
						if !current_issue.nil?
							current_issue.recipes.find_or_create_by(title: row["recipe"], page: row["page"])
						end
									
					else
						puts "Unknown action record #{row['action']}"
					end
					
				else
					puts "Unknown type #{row['recipe']}"
				end
				
			end
			
		end
	end

	def loadRecipesByCategory()
		
		
		filename = "#{@mag_title}_#{@yr}_idx_catandrecipewithkey.csv"
		fileInput = Rails.root.join('db','seeds','dbloadfiles',filename)
		
		catTypeI = Categorytype.find_by(code: 'I')
		catTypeT = Categorytype.find_by(code: 'S')
		
		puts "loading #{@mag_title}_#{@yr}_categories.csv"
		
		current_category = nil
		count = 0
		
		if validFileHeader?(fileInput,filename)
								
				# Header : 
				#	type		- content of the row
				# action	- type of action to the database	
				# issue		- the issue for the year where the recipe is found
				# page		- the page in the issue where the recipe is found
				# recipe	- the recipe title
				# keyword - word or phrase from the recipe that matches the category 
				
			# fetch the style of recipes to find based on the file type read from the header
			this_recipe = recipeFinder
			
			CSV.foreach(fileInput, {col_sep: "\t", headers: :true}) do |row|
				
				case row["type"]
				when "H"
					# header row checked above so ignore
				when "C"
					# category stored in the issue column
					case row["issue"]
					when "ingredient:"
						catType = catTypeI 
					when "category:"
						catType = catTypeT
					else
						catType = nil
						puts "Unknown category type  #{row["issue"]}"
					end
					if !catType.nil?
						current_category = catType.categories.find_by(name: row["page"])
					else
						current_category = nil
						puts "Unknown category  #{row["page"]}"
					end
				when "r"
					case row["action"]
					when "l"
						# lookup up recipe to add
						
						# confirm we have a category to add to
						if !current_category.nil?
							#set the issue for finding the recipe Id
							this_recipe.issue = row["issue"]
							# look up the receipe record
							recipe = this_recipe.recipe(row["recipe"],row["page"])
							if recipe.nil?
								puts "Missing recipe: #{row["issue"]} #{row["recipe"]}"
							else
								catRecipe = current_category.category_recipes.find_by(recipe_id: recipe.id)
								if catRecipe.nil?
									catRecipe = current_category.category_recipes.create(recipe_id: recipe.id, keyword: row["keyword"])
									count += 1
								end
							end
						end
					end
				end
						
			end			
			puts "#{count} recipes added to category"			
		end
	end
  
	
	private
	
	def validFileHeader?(fileInput,filename)
		# the initial line to veify it is the correct style of file to process
		
		valid_file = false
	
		if !File.exists?(fileInput)
			puts "Missing file #{fileInput}"
		else
			puts "Loading #{filename}"
		
			file = File.open(fileInput, "r")
			#Read over csv header line
			line = file.readline
			# read file header details
			line = file.readline
			this_header = line.chomp.split("\t")
			
			# lookup style of data, by year or by issue number
			@filestyle = this_header[3]   
			case @filestyle
				when 'byyear' 
						
					yr = header_line_byyear(line)
					if yr != @yr
						puts "Invalid year record #{line} in #{fileInput}"
					else 
						valid_file = true
					end
				when 'byissueno' 
					isnos = header_line_byissue(line)
					
					if isnos != @issueNumRange
						puts "Invalid issue range #{line} in #{fileInput}"
					else
						valid_file = true
					end
				else
					puts "Invalid header record #{line} missing filestyle in #{fileInput}"
			end
			file.close
		end
		return valid_file
	end
	
	
	def find_issue(issuedescriptions, is_title)
		is = nil

		issuedescriptions.each do |row|
			if row[:title] == is_title
	 			is = row.issues.first
	 			break
	 		end
		end
	
		return is 
	end
	
	def file_data(line)
		# confirms the passed line contains a title 
		if line.match(/recipe index/) then
			# does it contain keyword  for by year
			if line.match(/year/) then
				return :byYear
			end
		end
	end
	
	
	def header_line_byyear(line)
		# confirms the passed line contains a title and a 4 digit year value
		
		if line.match(/recipe index/) then
			#fetch year and convert to integer
			match_yr =  line.match(/\s*\d{4}/)
			if match_yr 
				return match_yr[0].to_i
			end
		end
		
		return 0
	end
	
	def header_line_byissue(line)
		# confirms the passed line contains a title and a range of numbers
		if line.match(/recipe index/) then
			#fetch range of issue numbers
			match_issue_range =  line.match(/\d{1,3}-\d{1,3}/)
			if match_issue_range
				return match_issue_range[0]
			end
		end
		
		return 0
	end
	
	def recipeFinder
		case @filestyle
			when 'byyear' 
				return FindRecipeByYear.new(@yr)
			when 'byissueno'
				return FindRecipeByIssue.new
		end
	end
end

class CategoryImporter

	def initialize(yr,mag_title)
		
		# store the year of publication
		@yr = yr
		# store the short name used in the extract file
		@mag_title = mag_title
		
	end
	
	def load_categories
		
		filename = "#{@mag_title}_#{@yr}_categories.csv"
		fileInput = Rails.root.join('db','seeds','dbloadfiles',filename)
		
		puts "loading #{@mag_title}_#{@yr}_categories.csv"
		
		#track how many updates
		count = 0
		
		catTypeI = Categorytype.find_by(code: 'I')
		catTypeT = Categorytype.find_by(code: 'S')

		CSV.foreach(fileInput, {col_sep: "\t", headers: :true}) do |row|
			
			recipe = row["recipe"].strip
			case row["category"]
			when "ingredient:"
				catTypeI.categories.find_or_create_by(name: recipe)
				count += 1
			when "category:"		
				catTypeT.categories.find_or_create_by(name: recipe)
				count += 1
			else
				puts "Unknown Category: #{row["category"]}"
			end
				
		end
		puts "Categories processed: #{count}"
	end
	
	
	
end



class FindRecipeByYear 
	attr_accessor   :year, :issue
	def initialize(year)
		@year = year
	end
	
	def recipe(recipeTitle,page)
		this_issue = @issue.gsub("Dec","Dec-Jan")
		return Recipe.joins(issue: :issuedescription).
			where('issuedescriptions.title = ? and issues.year = ? and recipes.title = ? and page = ?',
				this_issue, @year, recipeTitle, page).first
		
	end
end

class FindRecipeByIssue 
	attr_accessor :issue
	def recipe(recipeTitle,page)
		return Recipe.joins(:issue).where('issues.no = ? and recipes.title = ? and page = ?',
			@issue.to_i,recipeTitle,page).first
	end
end

class UrlImporter
	def initialize(mag_title)
	
		# store the short name used in the extract file
		@mag_title = mag_title
			
	end
		
	def load_delicious_urls
		
		filename = "#{@mag_title}_urls.csv"
		fileInput = Rails.root.join('db','seeds','dbloadfiles',filename)
		
		puts "loading #{filename}"
		
		#track how many updates
		count = 0
			
		CSV.foreach(fileInput, {col_sep: "\t", headers: :true}) do |row|
			
			recipe = Recipe.joins(issue: :issuedescription).
				where(" issuedescriptions.title = ? AND issues.year = ? AND page = ? AND recipes.title = ? ",
				row["issue"], row["year"],row["page"],row["recipe"]).take
			if recipe.nil?
				puts "#{row['recipe']} not found"
			else
				recipe.url = row["url"]
				recipe.save
				count += 1
			end
		end
		
		puts "Recipes updated: #{count}"
	end			
		
					
					
					
end