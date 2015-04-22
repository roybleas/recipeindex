

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