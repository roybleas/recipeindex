# == Schema Information
#
# Table name: issues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  publication_id      :integer
#  issueyear_id        :integer
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no                  :integer
#

class Issue < ActiveRecord::Base
  belongs_to :publication
  belongs_to :issueyear
  belongs_to :issuedescription
  has_many :recipes
  
  
	validates :title, presence: {if: Proc.new { |issue| issue.no.blank? }}
  validates :no, presence: {if: Proc.new { |issue| issue.title.blank? }}
  	
end
