class PostsController < ApplicationController
  
  def index
    @posts = Post.all.includes(:user, :likes, :comments)
    render json: @posts, each_serializer: PostSerializer, scope: @current_user
  end

  def show
    posts = @current_user.posts.find(params[:id])
    render json: posts
  end

  def create
    post = @current_user.posts.new(post_params)
    if post.save
      render json: post, status: 200
    else
      render json: post.errors.full_messages
    end
  end

  def update
    post = @current_user.posts.find(params[:id])
    if post.user == @current_user && post.update(post_params)
      render json: post
    else
      render json: { error: 'Unable to update this post' }
    end
  end

  def destroy
    post = @current_user.posts.find(params[:id])
    if post.user == @current_user
      post.destroy
      render json: { message: 'Post Deleted Succesfull' }, status: 200
    else
      render json: { error: 'Unable to delete this post' }
    end
  end

  private

  def post_params
    params.require(:posts).permit(:caption, photos: [])
  end
end
