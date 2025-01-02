class LikesController < ApplicationController
  before_action ::authenticate_user!
  before_action :set_post

  # POST /posts/:post_id/likes
  def create
    if @post.likes.exists?(user: @current_user)
      render json: { error: 'You already liked this post' }, status: :unprocessable_entity
    else
      @like = @post.likes.new(user: @current_user)
      if @like.save
        render json: { message: 'Post liked successfully' }, status: :created
      else
        render json: { error: 'Unable to like post' }, status: :unprocessable_entity
      end
    end
  end

  # DELETE /posts/:post_id/likes
  def destroy
    @like = @post.likes.find_by(user: @current_user)
    if @like
      @like.destroy
      render json: { message: 'Like removed successfully' }, status: :ok
    else
      render json: { error: 'You have not liked this post' }, status: :not_found
    end
  end

  private

  # Find the post by ID
  def set_post
    @post = Post.find(params[:post_id])
  end
end
