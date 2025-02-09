class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user

  belongs_to :user, serializer: UserSerializer
end