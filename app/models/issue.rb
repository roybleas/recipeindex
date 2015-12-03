# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no                  :integer
#  year                :integer
#

class Issue < ActiveRecord::Base

  belongs_to :issuedescription
  has_many :recipes
  has_one :publication, through: :issuedescription
  has_many :user_issues
  has_many :users, through: :user_issues

  
  validates :year, presence: true
  validates_numericality_of :year, less_than: Time.new.year + 1
  validates_numericality_of :year, greater_than: 1989
  # must have either a title or a number or both
	validates :title, presence: {if: Proc.new { |issue| issue.no.blank? }}
  validates :no, presence: {if: Proc.new { |issue| issue.title.blank? }}
  
  def self.for_issuemonth_and_publication(mnth,pub_id)
    joins([issuedescription: :issuemonths]).where("issuemonths.monthindex = ? and issuedescriptions.publication_id = ?", mnth,pub_id).order(year: :asc)
  end
  
  def self.and_description_title_for_recipe(recipe_id)
		select("issues.*,issuedescriptions.title as issuedescription_title, publications.title as publication_title").joins(:recipes, {issuedescription: :publication}).where("recipes.id = ?",recipe_id)
	end
	
	def self.by_publication(publication_id)
		joins(:issuedescription).where("issuedescriptions.publication_id = ?" , publication_id).order("issues.year asc", "issuedescriptions.seq asc").all
	end
	
	def self.with_linked_user(publication_id,user_id)
		select("issues.id, issues.no, issues.year, user_issues.user_id as user_id").joins("INNER JOIN issuedescriptions ON issues.issuedescription_id = issuedescriptions.id LEFT OUTER JOIN user_issues ON issues.id = user_issues.issue_id and user_issues.user_id = #{user_id}").where("publication_id = ? ", publication_id).order("issues.year asc", "issuedescriptions.seq asc").all
	end
end

