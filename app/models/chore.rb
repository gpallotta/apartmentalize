class Chore < ActiveRecord::Base
  belongs_to :group, inverse_of: :chores
  belongs_to :user, inverse_of: :chores

  validates_presence_of :title
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :description

  attr_accessible :completed, :description, :title, :user_id
end
