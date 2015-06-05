require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
	
  context "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "renders the index template" do
			get :index
 			expect(response).to render_template :index
 		end
 		it "renders the index template via letter" do
			get :byletter, letter:'y'
 			expect(response).to render_template :index
 		end
  end
   
  context 'without params[:letter]' do
		it "populates a default array of categories a-b" do
			
			cattype = create(:categorytype, code: 'I')
			apple = create(:category, name: 'apple', :categorytype => cattype )
			zucchini = create(:category, name: 'zucchini' , :categorytype => cattype)
			 
			get :index					 
			expect(assigns(:categories)).to match_array([apple])
		end
	 end
	 
	 context 'with params[:letter]' do
 		before(:each) do
 			cattype = create(:categorytype, code: 'I')
 			
 			@apple = create(:category, name: 'apple', :categorytype => cattype )
			@zucchini = create(:category, name: 'zucchini' , :categorytype => cattype)
			@banana = create(:category, name: 'banana', :categorytype => cattype )
			@pear = create(:category, name: 'pears', :categorytype => cattype )
			@egg = create(:category, name: 'eggs', :categorytype => cattype )
 		end
 					
		it "populates an array a-b with the letter a or b" do
 			get :byletter, letter:'a'	 
			expect(assigns(:categories)).to match_array([@apple, @banana])
			
			get :byletter, letter:'b'	 
			expect(assigns(:categories)).to match_array([@apple, @banana])
		end
		
		it "creates an empty array for range c-d with the letter c" do
 			get :byletter, letter:'c'			 
			expect(assigns(:categories)).to be_empty
		end
		
		it "populates an array n-p with the letter o" do
 			get :byletter, letter:'o'	 
			expect(assigns(:categories)).to match_array([@pear])
		end

		it "populates an array q-z with the uppercase letter z" do
 			get :byletter, letter:'Z'	 
			expect(assigns(:categories)).to match_array([@zucchini])
		end

		it "populates an array e-m with the letter m and category S" do
			cattype = create(:categorytype, code: 'S')
			marinade = create(:category, name: 'marinades', :categorytype => cattype)

			get :byletter, letter:'m'
			expect(assigns(:categories)).to match_array([@egg,marinade])
		end
		
		it "creates a default array for range a-b with non-letter " do
	 		get :byletter, letter:'2'
	 		expect(assigns(:categories)).to match_array([@apple, @banana])
		end
	end
		
  context "GET show" do
    it "returns http success" do
    	cattype = create(:categorytype)
    	cat = create(:category, :categorytype => cattype )
      get :show, id: cat
      expect(response).to have_http_status(:success)
    end
  end

end
