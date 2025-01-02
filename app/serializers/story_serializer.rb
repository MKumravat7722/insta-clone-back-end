class StorySerializer < ActiveModel::Serializer
  attributes :id, :image_url, :photo, :created_at, :expires_at

  belongs_to :user

  def photo
    object.image.attached? ? object.image.url : []
  end
end
