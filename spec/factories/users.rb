FactoryBot.define do
  factory :user do
    full_name { 'New full name' } # ensures only letters & spaces
    username { Faker::Internet.unique.username(specifier: 5..8) }
    email { Faker::Internet.unique.email }
    password { 'Password@123' }
    bio { Faker::Lorem.sentence(word_count: 10) }

    # after(:build) do |user|
    #   user.profile_picture.attach(
    #     io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
    #     filename: 'test.png',
    #     content_type: 'image/png'
    #   )
    # end
  end
end
