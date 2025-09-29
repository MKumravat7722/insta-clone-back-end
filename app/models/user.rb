# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_picture
  has_many :posts, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :search_histories, dependent: :destroy
  has_many :searched_users, through: :search_histories, source: :searched_user

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followees, through: :followed_users, source: :followee
  
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :following_users, source: :follower

  PASSWORD_FORMAT = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x

  validates :password,
            presence: true,
            length: { in: 8..128 },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            on: :create

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
  # validates :profile_picture, presence: true
  validates :bio, length: { maximum: 500 }, allow_nil: true

  validates :password_reset_token, uniqueness: true, allow_nil: true
  validates :password_reset_sent_at, presence: true, if: -> { password_reset_token.present? }

  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.current
    update_columns(
      password_reset_token: password_reset_token,
      password_reset_sent_at: password_reset_sent_at
    )
  end

  def clear_password_reset_token!
    update(password_reset_token: nil, password_reset_sent_at: nil)
  end
end
