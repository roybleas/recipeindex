# == Schema Information
#
# Table name: publications
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  published   :string(255)
#  description :string(255)
#

class Publication < ActiveRecord::Base
	has_many :issuedescriptions
	has_many :issues, through: :issuedescriptions
	validates :title, presence: true, uniqueness: true
end
