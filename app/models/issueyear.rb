# == Schema Information
#
# Table name: issueyears
#
#  id             :integer          not null, primary key
#  year           :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Issueyear < ActiveRecord::Base
  belongs_to :publication
  has_many :issues
  
  validates :year, presence: true
  validates_numericality_of :year, less_than: Time.new.year + 1
  validates_numericality_of :year, greater_than: 1989
  validates_uniqueness_of :year, scope: :publication_id
end
