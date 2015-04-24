class IssuesController < ApplicationController
  def index
  	# Note not a true index of all issue records.
  	# instead it shows the distinct year fields by publication and selects the Issue Id for each publication for the current month
  	# this is then used in a link to show the Issue
  	
  	# select years for each index by current month 
  	# this is to cater for Dec/Jan month so even if current month is January the issue might be for the previous year
  	@mnth = Time.now.month
  	@pubs = Publication.all
  	
  	render 'index'
  end

  def show
  	#save the parameter as an integer 
  	issue_id = params[:id].to_i
  	@issue = Issue.find(issue_id)
  	@issuedesc = Issuedescription.joins(:issues).where("issues.id = ?", issue_id).take
  	@pub = Publication.joins(:issues).where("issues.id = ?", issue_id).take
  	years = Issue.where(issuedescription_id: @issuedesc.id).order(year: :asc).all
  	
  	#find the next and previous year records for the passed issue
  	@year_before = nil
  	@year_after = nil
  	(0...years.size).each do |idx|
  		if years[idx].id == issue_id 
  			@year_before = years[idx - 1] unless idx == 0
  			@year_after = years[idx + 1] unless idx == years.size
  			break
  		end
  	end
  	
  	#find the next and previous issuedescriptions
  	min_sequence = @pub.issuedescriptions.minimum("seq")
  	max_sequence = @pub.issuedescriptions.maximum("seq")
  	
  	current_sequence = @issuedesc.seq
  	
  	# set previous to one less than current unless it is minimum then cycle round to maximum  	
  	previous_sequence = current_sequence == min_sequence ? max_sequence : current_sequence - 1
  	
  	# set next to one greater than current unless it is maximum then cycle back to minimum  	
  	next_sequence = current_sequence == max_sequence ? min_sequence : current_sequence + 1
  	
  	@previous_issuedescription = Issue.joins(:issuedescription).where("issuedescriptions.seq = ? and year = ?",previous_sequence,@issue.year).take
  	@next_issuedescription = Issue.joins(:issuedescription).where("issuedescriptions.seq = ? and year = ?",next_sequence,@issue.year).take
  	
  	@recipies = Recipe.where("issue_id = ?", issue_id).order(title: :asc).all
  	
  	render 'show'
  end
  
  def years
  	@issue_id = params[:id].to_i
  	@pub = Publication.joins(:issues).where("issues.id = ?", @issue_id).take
  	@years = Issue.joins(
  		"inner join issuedescriptions on issues.issuedescription_id = issuedescriptions.id" \
  		" inner join issues as I2 on issuedescriptions.id = I2.issuedescription_id" \
  		).where("I2.id = ?",@issue_id).order(year: :asc).all
  	
  	render 'years'
	end
  
  private 
  
  	def issue_params
  		params.require(:issue).permit(:id)
  	end
end
