# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :username, :email, :profile_picture_url, :posts_count, :bio
  has_many :posts
  has_many :followers
  has_many :followees
  has_many :stories

  def profile_picture_url
    object.profile_picture.url if object.profile_picture.attached?
  end

  def followers
    object.followers.count
  end

  def followees
    object.followees.count
  end

  def posts_count
    object.posts.count
  end
end
