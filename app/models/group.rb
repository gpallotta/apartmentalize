class Group < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :chores, dependent: :destroy
  has_many :managers, dependent: :destroy

  validates_presence_of :identifier

  attr_accessible :identifier
end
