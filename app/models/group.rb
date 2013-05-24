# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  identifier :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :chores, dependent: :destroy
  has_many :managers, dependent: :destroy

  validates_presence_of :identifier

  attr_accessible :identifier
end
