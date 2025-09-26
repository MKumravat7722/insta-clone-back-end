# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :follower_id, uniqueness: { scope: :followee_id }
  validates :followee_id, uniqueness: { scope: :follower_id }
  validates :follower_id, presence: true
  validates :followee_id, presence: true

  after_create :create_follow_notification

  private

  def create_follow_notification
    Notification.create(
      user: followee,
      notifiable: self,
      message: "#{follower.username} started following you"
    )
  end
end
