class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :photos, :created_at, :updated_at
  has_many :likes
  has_many :comments

  def photos
    object.photos.attached? ? object.photos.map { |photo| photo.url } : []
  end
end
