# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)      not null
#  group_id               :integer          not null
#

class User < ActiveRecord::Base

  has_many :debts_owed_to, class_name: "Debt",
      foreign_key: "user_owed_to_id", dependent: :destroy
  has_many :debts_they_owe, class_name: "Debt",
      foreign_key: "user_who_owes_id", dependent: :destroy
  has_many :comments
  has_many :chores
  belongs_to :group

  validates_presence_of :name
  validates_presence_of :group

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :name, :password_confirmation, :remember_me, :group

  def debts
    Debt.where("user_who_owes_id = ? or user_owed_to_id = ?", id, id)
  end
end
