# == Schema Information
#
# Table name: recipes
#
#  id         :integer          not null, primary key
#  title      :string
#  page       :integer
#  url        :string
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
  has_many :user_recipes
 	has_many :users, through: :user_recipes
 	
  validates :issue, presence: true
  validates :title, :page, presence: true
  
  def self.by_category(category)
  	select('recipes.* , publications.title as pub, issuedescriptions.title as desc , issues.year as year').joins(:categories).joins(issue: { issuedescription: :publication}).where('categories.id = ?',category.id).order(title: :asc).all 	
  end
  def self.by_category_and_user(category,user_id)
  	select('recipes.* , publications.title as pub, issuedescriptions.title as desc , issues.year as year, user_issues.id as user_owned').joins(:categories).joins(issue: { issuedescription: :publication}).joins("LEFT OUTER JOIN user_issues ON issues.id = user_issues.issue_id and user_issues.user_id = #{user_id}").where('categories.id = ?',category.id).order(title: :asc).all 	
  end
  def self.by_category_and_user_and_userrecipe(category,user_id)
  	select('recipes.* , publications.title as pub, issuedescriptions.title as desc , issues.year as year, user_issues.id as user_owned, user_recipes.like as user_recipes_like, user_recipes.rating as user_recipes_rating').joins(:categories).joins(issue: { issuedescription: :publication}).joins("LEFT OUTER JOIN user_issues ON issues.id = user_issues.issue_id and user_issues.user_id = #{user_id}").joins("LEFT OUTER JOIN user_recipes ON recipes.id = user_recipes.recipe_id and user_recipes.user_id = #{user_id}").where('categories.id = ?',category.id).order(title: :asc).all 	
  end
  def self.by_issue_and_user_ratings(issue_id,user_id)
  	select("recipes.*, user_recipes.like as user_recipes_like, user_recipes.rating as user_recipes_rating").joins('LEFT OUTER JOIN user_recipes on user_recipes.recipe_id = recipes.id').where("issue_id = ? and ( user_recipes.user_id = ? OR user_recipes.user_id IS NULL)", issue_id, user_id).order('lower(title) asc')
  end
end
                