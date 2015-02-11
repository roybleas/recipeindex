# == Schema Information
#
# Table name: issuedescriptions
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  full_title     :string(255)
#  seq            :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Issuedescription < ActiveRecord::Base
  belongs_to :publication
  has_many :issues
  
  validates :title, presence: true
  validates :full_title, presence: true
  validates :seq, presence: true
  
end
