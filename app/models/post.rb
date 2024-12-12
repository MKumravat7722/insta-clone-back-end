class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many_attached :photos

  validates :caption, presence: true
  validates :photos, presence: true

  after_create :create_post_notification

  private

  def create_post_notification
    Notification.create(
      user: user,
      notifiable: self,
      message: "#{user.username} created a new post"
    )
  end
end
