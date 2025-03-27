class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!
  include JwtToken
  def login
    @user = User.find_by(email: params[:email]) # Fix the typo in the attribute name
    if @user&.authenticate(params[:password])
      token = jwt_encode({ user_id: @user.id })
      Time.now
      24.hours.to_i
      render json: {
        token: token,
        user: UserSerializer.new(@user)
      }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
