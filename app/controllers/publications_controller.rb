class PublicationsController < ApplicationController
include Admin

before_action :admin_user?, only: [:edit]

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
		@issues = Issue.joins(:issuedescription).where("issuedescriptions.publication_id = ?" , publication_id).order("issues.year asc", "issuedescriptions.seq asc").all
  	
  	render 'issues'
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
