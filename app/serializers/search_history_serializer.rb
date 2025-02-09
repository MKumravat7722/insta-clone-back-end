class SearchHistorySerializer < ActiveModel::Serializer
  attributes :id, :created_at
  belongs_to :searched_user, serializer: UserSerializer
end