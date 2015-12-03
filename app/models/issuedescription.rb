# == Schema Information
#
# Table name: issuedescriptions
#
#  id             :integer          not null, primary key
#  title          :string
#  full_title     :string
#  seq            :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Issuedescription < ActiveRecord::Base
  belongs_to :publication
  has_many :issues
  has_many :issuemonths
  
  validates :title, presence: true
  validates :full_title, presence: true
  validates :seq, presence: true
  
end
