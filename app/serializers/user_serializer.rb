class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :username, :email, :profile_picture_url
  has_many :posts
  has_many :followers
  has_many :followees

  def profile_picture_url
    object.profile_picture.service_url if object.profile_picture.attached?
  end
end
