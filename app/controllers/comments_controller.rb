class CommentsController < ApplicationController
  before_action ::authenticate_user!
  before_action :set_post, only: %i[create destroy]
  before_action :set_comment, only: [:destroy]

  def create
    comment = @post.comments.build(comment_params.merge(user: @current_user))
    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      render json: { message: 'Comment deleted successfully' }, status: :ok
    else
      render json: { errors: 'Failed to delete comment' }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
    render json: { error: 'Post not found' }, status: :not_found unless @post
  end

  def set_comment
    @comment = @post.comments.find_by(id: params[:id])
    render json: { error: 'Comment not found' }, status: :not_found unless @comment
  end
end
