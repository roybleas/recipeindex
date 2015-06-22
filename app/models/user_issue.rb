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

class UserIssue < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue
end
