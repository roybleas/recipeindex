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
  	issue_id = params[:id]
  	@issue = Issue.find(issue_id)
  	@issuedesc = Issuedescription.joins(:issues).where("issues.id = ?", issue_id).take
  	@pub = Publication.joins(:issues).where("issues.id = ?", issue_id).take
  	@years = Issue.select(:year).distinct.joins(:publication).where("publications.id = ?",@pub.id).all
  	render 'show'
  end
  
  private 
  
  	def issue_params
  		params.require(:issue).permit(:id)
  	end
end
