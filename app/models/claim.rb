class Claim < ActiveRecord::Base

  belongs_to :user_who_owes,
              class_name: 'User',
              foreign_key: "user_who_owes_id",
              inverse_of: :claims_to_pay

  belongs_to :user_owed_to,
              class_name: 'User',
              foreign_key: "user_owed_to_id",
              inverse_of: :claims_to_receive


  has_many :comments,
            dependent: :destroy,
            inverse_of: :claim

  validates_presence_of :title
  validates_presence_of :amount
  validates_length_of :description, maximum: 200
  validates_numericality_of :amount, :greater_than => 0
  validates_format_of :amount, with: /^\d+(\.\d{1,2})?$/,
      message: "Must have two or fewer digits after decimal"
  validates_presence_of :user_owed_to
  validates_presence_of :user_who_owes

  attr_accessible :amount, :description, :paid, :title, :paid_on

  class << self

    def unpaid
      where(:paid => false)
    end

    def paid
      where(:paid => true)
    end

  end

  def mark_as_paid
    update_attributes(paid: true, paid_on: Time.now)
  end

  def involves?(user)
    [
      user_owed_to,
      user_who_owes
    ].include?(user)
  end

end
