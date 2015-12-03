# == Schema Information
#
# Table name: publications
#
#  id          :integer          not null, primary key
#  title       :string
#  created_at  :datetime
#  updated_at  :datetime
#  published   :string
#  description :string
#

class Publication < ActiveRecord::Base
	has_many :issuedescriptions
	has_many :issues, through: :issuedescriptions
	has_many :recipes, through: :issues
	validates :title, presence: true, uniqueness: true
	
end
