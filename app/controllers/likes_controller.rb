class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create destroy show]

  def index
    @likes = Like.all
    render json: @likes
  end

  def show
    if @post
      render json: @post.likes
    else
      render json: { message: 'Invalid input' }, status: :unprocessable_entity
    end
  end

  def create
    @like = @post.likes.new(user: @current_user)
    if @like.save
      render json: { message: 'Like created successfully' }, status: :created
    else
      render json: { error: 'Like not created' }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @post.likes.find_by(user: @current_user)
    if @like
      @like.destroy
      render json: { message: 'Like removed successfully' }, status: :ok
    else
      render json: { message: 'Like does not exist' }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
end
