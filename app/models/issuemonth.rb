# == Schema Information
#
# Table name: issuemonths
#
#  id                  :integer          not null, primary key
#  monthindex          :integer
#  issuedescription_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Issuemonth < ActiveRecord::Base
  belongs_to :issuedescription
  
  validates :monthindex, presence: true
  validates_numericality_of :monthindex, less_than: 13
  validates_numericality_of :monthindex, greater_than: 0
  
  def self.for_month(mnth)
    where("issuemonths.monthindex = ?", mnth)
  end
  	
end
