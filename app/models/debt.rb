# == Schema Information
#
# Table name: debts
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :string(200)
#  amount      :decimal(10, 2)   not null
#  paid        :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Debt < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :amount
  validates_presence_of :paid

  validates_length_of :description, maximum: 200

  validates_numericality_of :amount, :greater_than => 0
  validates_format_of :amount, with: /^\d+(\.\d{1,2})?$/,
      message: "Must have two or fewer digits after decimal"

  attr_accessible :amount, :description, :paid, :title
end
