class FollowsController < ApplicationController
  before_action :authenticate_user

  def follow
    user = User.find(params[:id])

    if @current_user.followees.exists?(user.id)
      render json: { error: 'You are already following this user' }, status: :unprocessable_entity
    elsif @current_user.followees << user
      render json: { message: "Successfully followed #{user.full_name}" }, status: :ok
    else
      render json: { error: 'Unable to follow user' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def unfollow
    user = User.find(params[:id])
    follow = @current_user.followed_users.find_by(followee_id: user.id)

    if follow
      follow.destroy
      render json: { message: "Successfully unfollowed #{user.full_name}" }, status: :ok
    else
      render json: { error: 'Unable to unfollow user' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
end
