class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_picture
  has_many :posts, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followed_users, source: :followee
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :following_users, source: :follower

  validates :email, presence: true, uniqueness: true, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: 'must be a valid email address'
  }

  validates :username, presence: true, uniqueness: true, length: {
    minimum: 3,
    maximum: 20,
    message: 'must be between 3 and 20 characters'
  }

  validates :full_name, presence: true, format: {
    with: /\A[a-zA-Z\s]+\z/,
    message: 'can only contain letters and spaces'
  }
end
