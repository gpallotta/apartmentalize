class UserMailer < ActionMailer::Base

  include Resque::Mailer

  default from: "apartment.com"

  def signup_welcome(user_id)
    user = User.find(user_id)
    mail to: user.email, subject: 'Welcome to Apartment'
  end

  def send_weekly_summary
    users = User.where("receives_weekly_email = true")
    users.each do |u|
      weekly_summary(u.id).deliver
    end
  end

  def weekly_summary user_id
    @user = User.find(user_id)
    @claim_balance = ClaimBalance.new(@user, @user.claims)
    mail to: @user.email, subject: 'Apartment - Weekly Summary'
  end

  def send_daily_summary
    users = User.where("receives_daily_email = true")
    users.each do |u|
      self.daily_summary(u.id).deliver
    end
  end

  def daily_summary user_id
    @user = User.find(user_id)
    @claims = @user.claims.
      where("DATE(created_at) = DATE(?) and user_who_owes_id = ?", Time.now, user_id)
    mail to: @user.email, subject: 'Apartment - Daily Summary'
  end

end
