class PublicationsController < ApplicationController
include Admin

before_action :admin_user?, only: [:edit]

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
  
  def show
  
	end



private 
  
  	def publication_params
  		params.require(:publication).permit(:title, :published, :description)
  	end
  	
  	#before filters
 # 	def admin_user?
 # 		
 # 		if not logged_in?
 # 			redirect_to login_url
 # 		else
 # 			unless current_user.admin? 
 # 				flash[:danger] = "Only administrators allowed to edit."
 # 				redirect_to root_url
 # 			end
 # 			return true
 # 		end
 # 	end
  	
  		
end
