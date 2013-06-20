class Donation < ActiveRecord::Base

  validates_presence_of :email
  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0
end