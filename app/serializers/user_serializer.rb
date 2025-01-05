class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :username, :email, :profile_picture_url
  has_many :posts
  has_many :followers
  has_many :followees
  has_many :stories

  def profile_picture_url
    object.profile_picture.url if object.profile_picture.attached?
  end
end

    