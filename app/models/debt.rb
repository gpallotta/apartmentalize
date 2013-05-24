# == Schema Information
#
# Table name: debts
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  description      :string(200)
#  amount           :decimal(10, 2)   not null
#  paid             :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_owed_to_id  :integer          not null
#  user_who_owes_id :integer          not null
#

class Debt < ActiveRecord::Base
  belongs_to :user_owed_to, class_name: 'User', foreign_key: "user_owed_to_id"
  belongs_to :user_who_owes, class_name: 'User', foreign_key: "user_who_owes_id"

  validates_presence_of :title
  validates_presence_of :amount
  validates_presence_of :paid
  validates_length_of :description, maximum: 200
  validates_numericality_of :amount, :greater_than => 0
  validates_format_of :amount, with: /^\d+(\.\d{1,2})?$/,
      message: "Must have two or fewer digits after decimal"
  validates_presence_of :user_owed_to
  validates_presence_of :user_who_owes

  attr_accessible :amount, :description, :paid, :title
end
