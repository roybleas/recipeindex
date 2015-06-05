# == Schema Information
#
# Table name: categorytypes
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Categorytype < ActiveRecord::Base
	has_many :categories
	
	validates :name, presence: true, uniqueness: true
	validates :code, presence: true, uniqueness: true
	
	def self.by_ingredient()
  	where(code: 'I')
  end
  
  def self.by_style()
  	where(code: 'S')
  end

	def self.by_list
		where(code: %w[I S])
	end
end
