# == Schema Information
#
# Table name: meals
#
#  id          :integer          not null, primary key
#  description :string(255)
#  seq         :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Meal < ActiveRecord::Base
	has_many :recipes
	
	validates :description, presence: true
	validates :seq, presence: true
end
