# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    association :user  # automatically creates a user if none is provided
    caption { "Sample caption" }

    after(:build) do |post|
      # attach a fixture image for ActiveStorage
      file_path = Rails.root.join('spec/fixtures/files/test_image.png')
      post.photos.attach(io: File.open(file_path), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end
