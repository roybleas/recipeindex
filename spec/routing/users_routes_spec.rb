require 'rails_helper'

RSpec.describe "routes to the user controller" do
  it "routes a sign up route" do
    expect(:get => signup_path).
      to route_to(:controller => "users", :action => "new")
  end
end
