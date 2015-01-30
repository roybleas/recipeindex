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
#  remember_digest :string(255)
#  admin           :boolean
#

FactoryGirl.define do
	factory :user do
		name "Fred Flintstone"
		screen_name "Fred F"
		password "foobar"
		password_confirmation "foobar"
	end
	
	factory :invalid_user, class: User do
		name nil
		screen_name nil
		password nil
		password_confirmation nil
	end
	
	factory :admin_user, class: User do
		name "Barney Rubble"
		screen_name "Barney"
		password "password"
		password_confirmation "password"
		admin true
	end
	
end
