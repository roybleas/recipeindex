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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_issue do
    
  end
end
