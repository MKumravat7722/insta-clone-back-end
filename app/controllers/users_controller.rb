class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :search]

  def index
    render json: @current_user
  end

  def show 
    user = User.find(params[:id])
    render json: user
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'User created successfully', user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user, status: :ok
    else
      render json: { error: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
    render json: { message: 'User deleted successfully' }, status: :ok
  end

  def search
    if params[:query].present?
      users = User.where('username LIKE ? OR email LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
      users.each { |user| save_search_history(user) }
      render json: users, each_serializer: UserSerializer
    else
      render json: { error: 'Query parameter is missing' }, status: :bad_request
    end
  end
 
  def top_liked

  end 

  
  def search_history
    search_histories = @current_user.search_histories.includes(:searched_user).order(created_at: :desc).limit(10)
    render json: search_histories, each_serializer: SearchHistorySerializer
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :username, :email, :bio, :password, :profile_picture)
  end

  def save_search_history(searched_user)
    if @current_user
      @current_user.search_histories.create(searched_user: searched_user)
    else
      Rails.logger.error "Attempted to save search history without a current user"
    end
  end
end