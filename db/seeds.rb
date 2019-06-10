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
# User.destroy_all

User.create!(
  [
    { email: "francesco@example.com", password: "password", first_name: "Francesco", last_name: "Mari", username: "sekmo" },
    { email: "chiara@example.com", password: "password", first_name: "Chiara", last_name: "Sag", username: "chiara" },
    { email: "andrew@example.com", password: "password", first_name: "Andrew", last_name: "Black", username: "andrew" },
    { email: "mark@example.com", password: "password", first_name: "Mark", last_name: "Stilton", username: "mark" },
    { email: "michael@example.com", password: "password", first_name: "Micheal", last_name: "Green", username: "michael" },
    { email: "arnold@example.com", password: "password", first_name: "Arnold", last_name: "White", username: "arnold" },
    { email: "mattew@example.com", password: "password", first_name: "Mattew", last_name: "Lord", username: "mattew" },
    { email: "patrick@example.com", password: "password", first_name: "Patrick", last_name: "King", username: "patrick" },
    { email: "jack@example.com", password: "password", first_name: "Jack", last_name: "Steward", username: "jack" }
  ]
)

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

puts "Users and Friendships created. ❤️"
