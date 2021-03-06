# == Schema Information
#
# Table name: category_recipes
#
#  id          :integer          not null, primary key
#  keyword     :string
#  category_id :integer
#  recipe_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CategoryRecipe < ActiveRecord::Base
  belongs_to :category
  belongs_to :recipe
  has_many :issuemonths, through: :recipe
  has_many :user_recipes, through: :recipe
  #has_many :category_recipes, class_name: "CategoryRecipe", foreign_key: "recipe_id"
  #belongs_to :category_recipes, class_name: "CategoryRecipe"
  
  def self.keywords_list_by_category(category_id)
  	select('cr2.keyword, cr2.category_id, cr2.recipe_id').joins('INNER JOIN public.category_recipes as cr2 ON category_recipes.recipe_id = cr2.recipe_id').where('category_recipes.category_id = ? and cr2.keyword is not null ',category_id)
  end
  
  def self.keywords_list_by_issue(issue_id)
  	joins(:recipe ).where('recipes.issue_id = ? and category_recipes.keyword is not null',issue_id)
  end
  
  def self.keywords_list_by_month(mnth)
  	joins(:issuemonths, :user_recipes ).where('issuemonths.monthindex = ? and category_recipes.keyword is not null',mnth)
  end
  # NB Extract function is postgres
  def self.by_lastused_by_month(mnth, user_id)
  	where("(EXTRACT(MONTH from user_recipes.lastused) = ? and user_recipes.like = 1) and user_recipes.user_id = ?", mnth, user_id)
  end
  def self.by_liked_by_month(mnth, user_id)
  	where("(issuemonths.monthindex = ? and user_recipes.like = 1) and user_recipes.user_id = ?", mnth, user_id)
  end
  
end
