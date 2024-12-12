class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :read, :created_at, :updated_at
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
end
