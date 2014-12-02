class UserController < ApplicationController
  def new
  end
  
  private 
  
  def user_params
  	params.require(:user).permit(:name, :screen_name)
  end
end
