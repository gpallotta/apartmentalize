class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_welcome.subject
  #
  def signup_welcome(user)
    mail to: user.email, subject: 'Welcome to Apartment'
  end

  def weekly_summary
    user_list.each do |u|
      Rails.logger.debug "emailis" + u.email
      @claim_balance = ClaimBalance.new(user, user.claims)
      @user = u
      mail to: u.email, subject: 'Apartment - Weekly Summary'
    end
  end

  def user_list
    User.where("receives_weekly_email = true")
  end

end
