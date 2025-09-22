class ApplicationController < ActionController::API
  include JwtToken

  before_action :authenticate_user!
  before_action do
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  private

  # Authenticate user using JWT
  def authenticate_user!
    header = request.headers['Authorization']&.split(' ')&.last
    if header.present?
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: 'Nil JSON web token' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: { error: e.message }, status: :unauthorized
  end

  # Handle record not found globally
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "#{exception.model || 'Record'} not found" }, status: :not_found
  end
end
