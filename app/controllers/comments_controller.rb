class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[index create]

  def index
    @comments = @post.comments
    render json: @comments
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Comment not found' }, status: :not_found
  end

  def create
    @comment = @post.comments.new(comment_params.merge(user: @current_user))
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { error: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
end
