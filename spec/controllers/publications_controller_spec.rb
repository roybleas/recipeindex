require 'rails_helper'

RSpec.describe PublicationsController, :type => :controller do
	
	before :each do
 		adminuser =  FactoryGirl.create(:admin_user)
 		session[:user_id] = adminuser.id
 	end


	describe 'GET #edit' do
		
		it "returns http success" do
			pub = FactoryGirl.create(:publication)
 			get :edit, id: pub
      expect(response).to have_http_status(:success)
    end
    
 		it "assigns the requested publication to publication" do
 			pub = FactoryGirl.create(:publication)
 			get :edit, id: pub
 			expect(assigns(:publication)).to eq pub
 		end
 			
 		it "renders the :edit template" do
 			pub = FactoryGirl.create(:publication)
			get :edit, id: pub
 			expect(response).to render_template :edit
 		end
 		
 		it "redirects to log in when not logged in" do
 			session[:user_id] = nil
 			pub = FactoryGirl.create(:publication)
			get :edit, id: pub
 			expect(response).to redirect_to login_url
 		end
 		
 		it "redirects to root when user is not admin" do
 			user =  FactoryGirl.create(:user)
 			session[:user_id] = user.id
 			pub = FactoryGirl.create(:publication)
			get :edit, id: pub
 			expect(response).to redirect_to root_url
 		end
 		
 	end
 	
 	describe "Patch update" do
 		
 		
 		context "valid attributes" do
 		
 			it "locates the requested publication" do
 				pub = FactoryGirl.create(:publication)
 				patch :update, id: pub, publication: attributes_for(:publication)
				expect(assigns(:publication)).to eq(pub)
			end
 			
 			it "changes the publication values" do
 				pub = FactoryGirl.create(:publication)
 				patch :update, id: pub, 
 						publication: attributes_for(:publication,
 							title:  "Delicious",
   						published: "Annually",
   						description: "ABC new food magazine.")
 				pub.reload
 				expect(pub.title).to eq('Delicious')
 				expect(pub.published).to eq('Annually')
 				expect(pub.description).to eq('ABC new food magazine.')
 			end
 			
 			it "redirects to updated publication" do
 				pub = FactoryGirl.create(:publication)
 				patch :update, id: pub, publication: attributes_for(:publication)
				expect(response).to redirect_to admin_pages_home_url
			end
 		end
	end

 	
end