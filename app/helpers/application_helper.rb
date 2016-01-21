module ApplicationHelper

# Returns true if the user is logged in as an administrator.
  def admin_user?
  	if current_user.nil?
  		false
  	else
  		current_user.admin?
  	end
  end

	def publications
		return  Publication.distinct.joins(:issuedescriptions).order(title: :asc).all
	end
	
	def user_current_month
		session[:user_favourite_month] ||= 	Time.now.month
		return session[:user_favourite_month]
	end
end
