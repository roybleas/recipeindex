require 'rails_helper'

RSpec.describe PublicationsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it "populates an array of publication titles" do
    	delicious = Publication.create(title: 'Delicious')
    	dish = Publication.create(title: 'Dish')
    	get :index
    	expect(assigns(:publications)).to match_array([delicious, dish])
    end
    
    it "renders the index template" do
    	get :index
    	expect(response).to render_template :index
    end
  end

end