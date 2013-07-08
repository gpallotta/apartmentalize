class UserMailer < ActionMailer::Base

  # include Resque::Mailer

  default from: "apartmentalize.info"

  def signup_welcome(user_id)
    user = User.find(user_id)
    mail to: user.email, subject: 'Welcome to Apartmentalize'
  end

  def weekly_summary(user_id)
    @user = User.find(user_id)
    @claim_balance = ClaimBalance.new(@user, @user.claims)
    mail to: @user.email, subject: 'Apartmentalize - Weekly Summary'
  end

  def daily_summary(user_id)
    @user = User.find(user_id)
    @claims = @user.claims_owed_and_created_today
    mail to: @user.email, subject: 'Apartmentalize - Daily Summary'
  end

end
