class UsersController < ApplicationController
  skip_before_action ::authenticate_user!, only: [:create]

  def index
    render json: @current_user
  end

  def show
    user = User.find(params[:id])
    follower_ids = user.followers.pluck(:follower_id)
    followee_ids = user.followees.pluck(:followee_id)
    post_user_ids = (follower_ids + followee_ids + [user.id]).uniq
    @posts = Post.where(user_id: post_user_ids)
    render json: @posts
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.with(user: @user).welcome_email.deliver_now
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

  private

  def user_params
    params.require(:user).permit(:full_name, :username, :email, :password, :profile_picture)
  end
end
