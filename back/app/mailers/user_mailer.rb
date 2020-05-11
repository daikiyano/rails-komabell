class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.magic_login_email.subject
  #
  def magic_login_email(user,url)
    @user = user
    @url  = url
    mail to: ENV.fetch("USER_NAME")
  end

  def magic_signup_email(user,url)
    @user = user
    @url  = url
    mail to: ENV.fetch("USER_NAME")
  end
end
