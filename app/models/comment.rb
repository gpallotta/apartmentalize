class Comment < ActiveRecord::Base

  belongs_to :claim, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates_presence_of :content
  validates_presence_of :claim
  validates_presence_of :user

  attr_accessible :content, :claim_id, :user_id


  class << self

    def most_recent_first
      order("created_at DESC")
    end

    def oldest_first
      order("created_at ASC")
    end

  end

end
