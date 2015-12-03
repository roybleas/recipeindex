# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string
#  seq             :integer
#  categorytype_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Category < ActiveRecord::Base
  belongs_to :categorytype
  has_many :category_recipes
  has_many :recipes, through: :category_recipe
  
  validates :name, presence: true, uniqueness: true
  validates :categorytype, presence: true
  
  def self.by_letter_range(letters)
  	where('lower(left(categories.name,1)) >= ? AND lower(left(categories.name,1)) <= ?', letters[0], letters[1]).order(:name)
  end
  
end
