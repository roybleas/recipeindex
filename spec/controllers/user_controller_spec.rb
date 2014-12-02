require 'rails_helper'

RSpec.describe UserController, :type => :controller do

  describe "GET signup" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end
