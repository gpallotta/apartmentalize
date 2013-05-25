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
