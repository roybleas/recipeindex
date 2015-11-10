require 'rails_helper'

class LayoutcalculationsController < ApplicationController
	include Layoutcalculations
end

RSpec.describe LayoutcalculationsController do

	it "sets column height to 1 for single entry with default column size" do
		size = 1
		expect( subject.column_height(size)).to eq(1)
	end
	
	it "sets column height to 1 when size matches columns" do
		size = 3
		expect( subject.column_height(size)).to eq(1)
	end
	
	it "sets column height to 2 when size greater than columns" do
		size = 4
		expect( subject.column_height(size)).to eq(2)
	end
	
	it "accepts a column number which is not the default" do
		size = 4
		expect( subject.column_height(size,4)).to eq(1)
	end

end