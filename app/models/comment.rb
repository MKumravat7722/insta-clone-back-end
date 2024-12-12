class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :content, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true

  after_create :create_comment_notification

  private

  def create_comment_notification
    Notification.create(
      user: post.user,
      notifiable: self,
      message: "#{user.username} commented on your post: #{post.caption}"
    )
  end
end
