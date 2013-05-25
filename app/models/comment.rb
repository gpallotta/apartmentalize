class Comment < ActiveRecord::Base

  belongs_to :debt
  belongs_to :user

  validates_presence_of :content
  validates_presence_of :debt
  validates_presence_of :user

  attr_accessible :content, :debt_id, :user_id


  class << self

    def most_recent_first
      order("created_at DESC")
    end

  end

end
