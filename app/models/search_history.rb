class SearchHistory < ApplicationRecord
  belongs_to :user
  belongs_to :searched_user, class_name: 'User'

  validates :user_id, presence: true
  validates :searched_user_id, presence: true
end