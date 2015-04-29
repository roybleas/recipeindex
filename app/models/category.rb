# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
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
end
