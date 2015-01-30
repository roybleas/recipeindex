class UsersController < ApplicationController
 before_action :logged_in_user, only: [:edit, :update, :show, :destroy, :index]
 before_action :correct_user,   only: [:show, :destroy]

  def show
  	@user = User.find(params[:id])
  end
  
  def new
  	@user = User.new
  end
  
  def create
  	@user = User.new(user_params)
  	if @user.save
  		log_in @user
  		flash[:success] = "Welcome"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  
   def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    if current_user.admin?
    	redirect_to users_url
    else
    	redirect_to root_url
  	end
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  	@usercount = User.count
  	@admin = current_user.admin?
  	
	end

  
  private 
  
  	def user_params
  		params.require(:user).permit(:name, :screen_name, :password, :password_confirmation)
  	end
  	
  	#before filters
  	def logged_in_user
  		unless logged_in?
  			flash[:danger] = "Please log in"
  			redirect_to login_url
  		end
  	end
  	
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
     
      unless current_user?(@user) or current_user.admin?
      	flash[:danger] = "Please log in with the correct user name."
      	redirect_to(root_url)
      end
    end
end
