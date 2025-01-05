class StorySerializer < ActiveModel::Serializer
  attributes :id, :image_url, :video_url, :user_id,  :created_at, :expires_at

  belongs_to :user

  def image_url
    object.image.attached? ? object.image.url : []
  end

  def video_url
    object.video.attached? ? object.video.url : []
  end
end
