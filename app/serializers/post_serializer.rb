# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :photos, :created_at, :updated_at, :isLiked, :likes_count, :comments_count
  belongs_to :user
  has_many :likes
  has_many :comments, serializer: CommentSerializer

  def photos
    object.photos.attached? ? object.photos.map(&:url) : []
  end

  def isLiked
    object.likes.exists?(user: scope)
  end

  def likes_count
    object.likes.count
  end

  def comments_count
    object.comments.count
  end
end
