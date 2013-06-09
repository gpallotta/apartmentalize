class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_welcome.subject
  #
  def signup_welcome(user)
    @greeting = "Welcome to the app"

    mail to: user.email
  end
end
