class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one_attached :video
  validates :expires_at, presence: true
  scope :active, -> { where('expires_at > ?', Time.current) }
end
