class Publication < ActiveRecord::Base
	validates :title, presence: true, uniqueness: true
end
