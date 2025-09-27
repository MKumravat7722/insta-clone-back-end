# frozen_string_literal: true

# Handles user authentication (login with email and password).
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!
  include JwtToken

  def login
    @user = User.find_by(email: params[:email])

    if authenticated_user?
      render_success_response
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def authenticated_user?
    @user&.authenticate(params[:password])
  end

  def render_success_response
    token = jwt_encode({ user_id: @user.id })
    render json: {
      token: token,
      user: UserSerializer.new(@user)
    }, status: :ok
  end
end
