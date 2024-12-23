class UserMailer < ApplicationMailer
  default from: "mohitk@shriffle.com"
  layout 'mailer'
  def welcome_email
    @user=params[:user]
    mail(to: @user.email, subject: "Welcome To My Webside!")
  end   

  def password_reset(user)
    @user = user
    @reset_link = edit_password_url(@user.password_reset_token) 
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
