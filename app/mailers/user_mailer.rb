class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def signup_welcome(user)
    mail to: user.email, subject: 'Welcome to Apartment'
  end

  def send_weekly_summary
    users = User.where("receives_weekly_email = true")
    users.each do |u|
      weekly_summary(u).deliver
    end
  end

  def weekly_summary user
    @claim_balance = ClaimBalance.new(user, user.claims)
    @user = user
    mail to: user.email, subject: 'Apartment - Weekly Summary'
  end

  def send_daily_summary
    users = User.where("receives_daily_email = true")
    users.each do |u|
      daily_summary(u).deliver
    end
  end

  def daily_summary user
    @claims = user.claims.where("DATE(created_at) = DATE(?) and user_who_owes_id = ?", Time.now, user.id)
    mail to: user.email, subject: 'Apartment - Daily Summary'
  end

end
