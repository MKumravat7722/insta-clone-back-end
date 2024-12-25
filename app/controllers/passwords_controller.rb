class PasswordsController < ApplicationController
  skip_before_action :authenticate_user

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      UserMailer.password_reset(user).deliver_now
      render json: { message: 'Password reset instructions have been sent to your email.' }, status: :ok
    else
      render json: { errors: 'Email not found' }, status: :not_found
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user.nil?
      render json: { error: 'Invalid token' }, status: :not_found
    elsif @user.update(password_params)
      @user.clear_password_reset_token!
      render json: { message: 'Password has been reset!' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
