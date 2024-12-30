class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id

  # belongs_to :user
  # belongs_to :post

  def user_id
    object.user.id
  end
end
