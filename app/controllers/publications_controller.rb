class PublicationsController < ApplicationController
include Admin
include Userlogin
before_action :admin_user?, only: [:edit]
before_action :logged_in_user, only: [:userissues]

rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
  	@publications = Publication.all
  end
  
  def edit
  	@publication = Publication.find(params[:id])
	end
	
	def update
		@publication = Publication.find_by_id(params[:id])
		if @publication.update_attributes(publication_params)
  		flash[:success] = "Publication updated"
  		redirect_to admin_pages_home_url
  	else
  		render 'edit'
  	end
  end
  
  def issues
  	publication_id = params[:id]
		@publication = Publication.find(publication_id)
		@issuedescriptions = Issuedescription.where("issuedescriptions.publication_id = ?" , publication_id).order(seq: :asc).all
		
  	
  	if logged_in?
  		@issues = Issue.with_linked_user(publication_id,current_user.id)
  	else
  		@issues = Issue.by_publication(publication_id)
  		#@issues = Issue.joins(:issuedescription).where("issuedescriptions.publication_id = ?" , publication_id).order("issues.year asc", "issuedescriptions.seq asc").all
  	end
	end

	def userissues
  	publication_id = params[:id]
  	user_id = current_user.id
  	  	
		@publication = Publication.find(publication_id)
		@issuedescriptions = Issuedescription.where("issuedescriptions.publication_id = ?" , publication_id).order(seq: :asc).all
  	@issues = Issue.with_linked_user(publication_id,user_id)
	end
	
	def userissuesupdate
		publication_id = params[:id]
  	user_id = current_user.id
  	  	  	
  	view_issue_ids = params[:userissue].nil? ? [] : params[:userissue].map(&:to_i)
		
		userissues = UserIssue.joins(issue: :issuedescription).where("issuedescriptions.publication_id = ? AND ( user_issues.user_id = ? )",publication_id,user_id).all
		db_issue_ids = userissues.inject([]){ |id_list, issue| id_list << issue.issue_id}
			
		remove_ids = db_issue_ids - view_issue_ids
		insert_ids = view_issue_ids - db_issue_ids
		
		remove_userissues = UserIssue.where(issue_id: remove_ids)
		
		user = User.find(user_id)
		
		UserIssue.transaction do
			remove_userissues.each { |userissue| userissue.destroy}
			insert_ids.each {	| id |	user.user_issues.create(issue_id: id)}
		end
		
		if (remove_ids.size + insert_ids.size) == 0
			#nothing to save so stay where we are
			redirect_to action: "userissues", id: publication_id
		else
			flash[:success] = "Saved issue selection." 
			redirect_to action: "issues", id: publication_id
		end
	end
	

private 
  
  def publication_params
  	params.require(:publication).permit(:title, :published, :description)
  end
  	
	def record_not_found
		flash[:danger] = "Record not found."
  	redirect_to root_url
  end
end
