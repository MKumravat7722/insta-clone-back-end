# frozen_string_literal: true

FactoryBot.define do
  factory :search_history do
    association :user
    association :searched_user, factory: :user
  end
end
