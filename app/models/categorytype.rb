class Categorytype < ActiveRecord::Base
	has_many :categories
	
	validates :name, presence: true
	validates :code, presence: true
end
