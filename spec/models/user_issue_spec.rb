# == Schema Information
#
# Table name: user_issues
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  issue_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserIssue, :type => :model do
  it "can have an issue record linked to a user" do
  	issue = create(:issue_without_description)
  	user = create(:user)
  	user_issue = create(:user_issue, user_id: user.id, issue_id: issue.id)
  	expect(user_issue).to be_valid
	end
	
	it "can have many user records linked to an issue" do
  	issue = create(:issue_without_description)
  	user = create(:user)
  	user_issue = create(:user_issue, user_id: user.id, issue_id: issue.id)
  	expect(user_issue).to be_valid
  	issue = Issue.create(title: "Aug")
		user = User.create(name:  "Test User", screen_name: "Test 1", password: "password", password_confirmation: "password")
		userissue = user.user_issues.create(issue: issue)
		user2 = User.create(name:  "Test User Two", screen_name: "Test 2", password: "password", password_confirmation: "password")
		userissue = user2.user_issues.create(issue: issue)
	end
	
	it "can have many issue records linked to a user" do
  	issue = create(:issue_without_description)
  	issue2 = create(:issue_without_description)
  	user = create(:user)
  	user_issue = create(:user_issue, user_id: user.id, issue_id: issue.id)
  	expect(user_issue).to be_valid
  	user_issue2 = create(:user_issue, user_id: user.id, issue_id: issue2.id)
  	expect(user_issue2).to be_valid

	end
	
	it "can only have one issue record linked to a user once" do
    issue = create(:issue_without_description)
    user = create(:user)
    user_issue = create(:user_issue, user_id: user.id, issue_id: issue.id)
    expect { user_issue = create(:user_issue, user_id: user.id, issue_id: issue.id)}.
      to raise_error.with_message(/UniqueViolation/)
 
	end
end
