class Group < ActiveRecord::Base
  has_many :users, dependent: :destroy

  validates_presence_of :identifier

  attr_accessible :identifier
end
