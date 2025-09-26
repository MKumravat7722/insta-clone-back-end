# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  validate :unique_like_for_user, on: :create

  after_create :create_like_notification

  def unique_like_for_user
    return unless Like.exists?(user_id: user_id, post_id: post_id)

    errors.add(:base, 'User can like a post only once')
  end

  def self.unlike(user_id, post_id)
    like = Like.find_by(user_id: user_id, post_id: post_id)
    like&.destroy
  end

  private

  def create_like_notification
    Notification.create(
      user: post.user,
      notifiable: self,
      message: "#{user.username} liked your post: #{post&.photos}"
    )
  end
end
