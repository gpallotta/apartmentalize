class User < ActiveRecord::Base

  has_many :claims_to_receive,
            class_name: "Claim",
            foreign_key: "user_owed_to_id",
            dependent: :destroy,
            inverse_of: :user_owed_to

  has_many :claims_to_pay,
            class_name: "Claim",
            foreign_key: "user_who_owes_id",
            dependent: :destroy,
            inverse_of: :user_who_owes

  has_many :comments, inverse_of: :user
  has_many :chores, inverse_of: :user
  belongs_to :group, inverse_of: :users

  validates_presence_of :name
  validates_presence_of :group

  validates_uniqueness_of :name, :scope => [:group_id]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :name, :password_confirmation, :remember_me, :group

  def claims
    Claim.where("user_who_owes_id = ? or user_owed_to_id = ?", id, id)
  end

end
