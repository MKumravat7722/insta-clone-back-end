# db/seeds.rb

require 'faker'

puts "Seeding data..."

# Clean up
User.destroy_all
Post.destroy_all
Comment.destroy_all
Like.destroy_all
Follow.destroy_all

# Create Users
users = []
5.times do
  users << User.create!(
    full_name: Faker::Name.name,
    username: Faker::Internet.username(specifier: 5..8),
    email: Faker::Internet.unique.email,
    bio: Faker::Quote.famous_last_words,
    password: "Password@123"
  )
end

puts "Created #{users.count} users"

# Attach image path
image_path = Rails.root.join("spec/fixtures/files/test_image.png")

# Create Posts with image
users.each do |user|
  2.times do
    post = user.posts.new(
      caption: Faker::Quote.matz
    )

    post.photos.attach(
      io: File.open(image_path),
      filename: "test_image.png",
      content_type: "image/png"
    )

    post.save!  # now validation passes

    puts "Post with image created for #{user.username}"

    # Add comments
    2.times do
      post.comments.create!(
        content: Faker::Lorem.sentence(word_count: 6),
        user: users.sample
      )
    end

    # Add likes
    3.times do
      post.likes.create!(user: users.sample)
    end
  end
end


puts "Seeding finished ✅"
