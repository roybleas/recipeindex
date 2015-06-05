# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  page       :integer
#  url        :string(255)
#  issue_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Recipe < ActiveRecord::Base
  belongs_to :issue
 	has_many :category_recipes
 	has_many :categories, through: :category_recipes
 	has_one :issuedescription, through: :issue
 	has_one :publication, through: :issue
  
  validates :issue, presence: true
  validates :title, :page, presence: true
  
  
end
