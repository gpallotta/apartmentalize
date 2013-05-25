class Comment < ActiveRecord::Base
  scope :most_recent_first, order("created_at DESC")

  belongs_to :debt
  belongs_to :user

  validates_presence_of :content
  validates_presence_of :debt
  validates_presence_of :user

  attr_accessible :content, :debt_id, :user_id
end
