class Group < ActiveRecord::Base

  validates_presence_of :identifier

  attr_accessible :identifier
end
