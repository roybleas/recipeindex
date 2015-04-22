require 'rails_helper'

RSpec.describe AdminPagesController, :type => :controller do
	
	before :each do
 		adminuser =  FactoryGirl.create(:admin_user)
 		session[:user_id] = adminuser.id
 	end
 	
 		describe "GET home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
    
    it "populates an array of publication titles" do
    	feast = Publication.create(title: 'Feast')
    	dish = Publication.create(title: 'Dish')
    	get :home
    	expect(assigns(:publications)).to match_array([ feast, dish])
    end
    
    it "renders the index template" do
    	get :home
    	expect(response).to render_template :home
    end
  end
  

end
