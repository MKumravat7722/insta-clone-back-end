class PasswordsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      UserMailer.password_reset(user).deliver_later
      render json: { message: 'Password reset instructions sent to your email.' }, status: :ok
    else
      render json: { error: 'Email not found.' }, status: :not_found
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user&.password_reset_token_valid?
      render json: { message: 'Valid token' }, status: :ok
    else
      render json: { error: 'Invalid or expired token.' }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user&.password_reset_token_valid?
      if @user.reset_password!(params[:password])
        render json: { message: 'Password successfully reset.' }, status: :ok
      else
        render json: { error: 'Unable to reset password.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired token.' }, status: :unprocessable_entity
    end
  end
end
