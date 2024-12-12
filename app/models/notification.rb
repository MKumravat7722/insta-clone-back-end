class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :notifiable_type, presence: true
  validates :message, presence: true

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def mark_as_read
    update(read: true)
  end

  def mark_as_unread
    update(read: false)
  end
end
