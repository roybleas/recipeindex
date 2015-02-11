# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  page       :integer
#  url        :string(255)
#  issue_id   :integer
#  meal_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Recipe < ActiveRecord::Base
  belongs_to :issue
  belongs_to :meal
  
  validates :issue, presence: true
  validates :title, :page, presence: true
  
  
end
