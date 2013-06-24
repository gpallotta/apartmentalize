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

  has_many :activities_as_owner,
            class_name: 'Activity',
            foreign_key: 'owner_id',
            inverse_of: :owner,
            dependent: :destroy

  has_many :activities_as_recipient,
            class_name: 'Activity',
            foreign_key: 'recipient_id',
            inverse_of: :recipient

  has_many :comments, inverse_of: :user
  has_many :chores, inverse_of: :user
  belongs_to :group, inverse_of: :users

  validates_presence_of :name
  validates_presence_of :group

  validates_uniqueness_of :name, :scope => [:group_id]

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :name, :password_confirmation,
        :remember_me, :group_id, :receives_weekly_email, :receives_daily_email

  def claims
    Claim.where("user_who_owes_id = ? or user_owed_to_id = ?", id, id)
  end

  def register
    if save
      UserMailer.signup_welcome(id).deliver
    else
      false
    end
  end

  def claims_owed_and_created_today
    claims.where("DATE(created_at) = DATE(?) and user_who_owes_id = ?",
        Time.now, id)
  end

  def self.delete_unaccepted_invitations
    User.invitation_not_accepted.each do |u|
      u.destroy if u.invitation_sent_at < 7.days.ago
    end
  end

  def self.subscribed_to_weekly_email
    where("receives_weekly_email = true")
  end

  def self.subscribed_to_daily_email
    where("receives_daily_email = true")
  end

end
