# frozen_string_literal: true

class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id

  belongs_to :user
  belongs_to :post

  def user_id
    object.user.id
  end
end
