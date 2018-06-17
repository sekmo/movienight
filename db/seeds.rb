# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if !Rails.env.production?
  ActiveRecord::Base.connection.tables.each do |table|
    if !table.in? ["schema_migrations", "ar_internal_metadata"]
      puts "Truncating #{table}."
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
    end
  end
end

# Friendship.destroy_all
# Profile.destroy_all
# User.destroy_all

User.create!([
  { email: "francesco@example.com", password: "password", password_confirmation: "password" },
  { email: "chiara@example.com", password: "password", password_confirmation: "password" },
  { email: "andrew@example.com", password: "password", password_confirmation: "password" },
  { email: "mark@example.com", password: "password", password_confirmation: "password" },
  { email: "michael@example.com", password: "password", password_confirmation: "password" },
  { email: "arnold@example.com", password: "password", password_confirmation: "password" },
  { email: "mattew@example.com", password: "password", password_confirmation: "password" },
  { email: "patrick@example.com", password: "password", password_confirmation: "password" },
  { email: "jack@example.com", password: "password", password_confirmation: "password" },
])

Profile.create!([
  { first_name: "Francesco", last_name: "Mari", nickname: "sekmo", user: User.find(1) },
  { first_name: "Chiara", last_name: "Sag", nickname: "chiara", user: User.find(2) },
  { first_name: "Andrew", last_name: "Black", nickname: "andrew", user: User.find(3) },
  { first_name: "Mark", last_name: "Stilton", nickname: "mark", user: User.find(4) },
  { first_name: "Micheal", last_name: "Green", nickname: "michael", user: User.find(5) },
  { first_name: "Arnold", last_name: "White", nickname: "arnold", user: User.find(6) },
  { first_name: "Mattew", last_name: "Lord", nickname: "mattew", user: User.find(7) },
  { first_name: "Patrick", last_name: "King", nickname: "patrick", user: User.find(8) },
  { first_name: "Jack", last_name: "Steward", nickname: "jack", user: User.find(9) }
])

User.find(1).ask_friendship(User.find(2))
Friendship.last.confirm!
User.find(3).ask_friendship(User.find(1))
Friendship.last.confirm!
User.find(1).ask_friendship(User.find(4))
User.find(5).ask_friendship(User.find(1))
User.find(1).ask_friendship(User.find(6))
User.find(7).ask_friendship(User.find(1))
User.find(1).ask_friendship(User.find(8))
User.find(9).ask_friendship(User.find(1))

puts "Users, Profiles created."
