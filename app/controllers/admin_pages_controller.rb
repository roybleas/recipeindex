class AdminPagesController < ApplicationController
include Admin
before_action :admin_user?, only: [:home]


  def home
  	@publications = Publication.all
  end
end
