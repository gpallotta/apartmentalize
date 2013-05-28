class Chore < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :description

  attr_accessible :completed, :description, :title, :user_id
end
