class UserMailer < ApplicationMailer
  default from: 'mohitk@shriffle.com'
  layout 'mailer'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome To My Website!')
  end

  def password_reset(user)
    @user = user
    @reset_url = "http://localhost:5173/reset-password/#{@user.password_reset_token}"

    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
