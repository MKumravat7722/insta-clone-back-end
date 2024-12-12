class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :image_urls, :created_at, :updated_at
  has_many :likes
  has_many :comments

  def image_urls
    object.photos.map { |photo| photo.service_url if photo.attached? }
  end
end
