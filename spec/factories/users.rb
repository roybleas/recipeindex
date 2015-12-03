# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#  screen_name     :string
#  password_digest :string
#  remember_digest :string
#  admin           :boolean
#

FactoryGirl.define do
	factory :user do
		name "Fred Flintstone"
		screen_name "Fred F"
		password "foobar"
		password_confirmation "foobar"
	end
	
	factory :admin_user, class: User do
		name "Barney Rubble"
		screen_name "Barney"
		password "password"
		password_confirmation "password"
		admin true
	end
	
end
