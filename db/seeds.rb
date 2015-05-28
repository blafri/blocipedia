require 'faker'

# Seed the database with users
5.times do
  user = User.new(
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(8)
  )
  user.skip_confirmation!
  user.save!
end

# Create a user I can log in as
user = User.new(
  email:    'blayne.farinha@gmail.com',
  password: 'C00lness'
)
user.skip_confirmation!
user.save!

# Create a colection of all users
users = User.all

# Seed the database with sample wikis
100.times do
  Wiki.create!(
    title: Faker::Lorem.sentence(3, false, 0),
    body: Faker::Lorem.paragraph,
    user: users.sample
  )
end

puts "Database seeded with #{users.count} users"
puts "Database seeded with #{Wiki.count} wikis"