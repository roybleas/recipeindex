# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  screen_name     :string(255)
#  password_digest :string(255)
#

class User < ActiveRecord::Base
	
	validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
	validates :screen_name, presence: true, length: { maximum: 20 }
		
	has_secure_password
	validates :password, length: { minimum: 6 }
end
