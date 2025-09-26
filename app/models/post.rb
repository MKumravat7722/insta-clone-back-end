# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many_attached :photos

  validates :caption, presence: true
  validates :photos, presence: true

  after_create :create_post_notification

  def liked_by?(user)
    likes.exists?(user: user)
  end

  include AASM

  aasm column: 'state' do
    state :draft, initial: true
    state :published
    state :archived

    event :publish do
      transitions from: :draft, to: :published
    end

    event :archive do
      transitions from: %i[draft published], to: :archived
    end

    event :unarchive do
      transitions from: :archived, to: :draft
    end
  end

  private

  def create_post_notification
    Notification.create(
      user: user,
      notifiable: self,
      message: "#{user.username} created a new post"
    )
  end
end
