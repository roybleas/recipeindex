# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
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

  
  validates :year, presence: true
  validates_numericality_of :year, less_than: Time.new.year + 1
  validates_numericality_of :year, greater_than: 1989
  # must have either a title or a number or both
	validates :title, presence: {if: Proc.new { |issue| issue.no.blank? }}
  validates :no, presence: {if: Proc.new { |issue| issue.title.blank? }}
  
  def self.for_issuemonth_and_publication(mnth,pub_id)
    joins([issuedescription: :issuemonths]).where("issuemonths.monthindex = ? and issuedescriptions.publication_id = ?", mnth,pub_id)
  end
	
end
