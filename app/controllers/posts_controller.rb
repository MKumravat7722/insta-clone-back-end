class PostsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_post, only: %i[show update destroy]

  def index
    posts = Post.all.includes(:user, :likes, :comments)
    render json: posts, each_serializer: PostSerializer, scope: @current_user
  end

  def show
    render json: @post
  end

  def create
    post = @current_user.posts.new(post_params)
    if post.save
      render json: post, status: :ok
    else
      render json: post.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @post.user == @current_user && @post.update(post_params)
      render json: @post
    else
      render json: { error: 'Unable to update this post' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.user == @current_user
      @post.destroy
      render json: { message: 'Post Deleted Succesfull' }, status: :ok
    else
      render json: { error: 'Unable to delete this post' }, status: :unprocessable_entity
    end
  end

  private

  # Strong params
  def post_params
    params.require(:posts).permit(:caption, photos: [])
  end

  # Set post for show, update, destroy
  def set_post
    @post = @current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
end
