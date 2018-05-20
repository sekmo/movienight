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
  { email: "mario@example.com", password: "password", password_confirmation: "password" },
  { email: "andrea@example.com", password: "password", password_confirmation: "password" }
])

Profile.create!([
  { first_name: "Francesco", last_name: "Mari", nickname: "sekmo", user: User.find(1) },
  { first_name: "Chiara", last_name: "Sag", nickname: "chiarasag", user: User.find(2) },
  { first_name: "Mario", last_name: "Rossi", nickname: "marione", user: User.find(3) },
  { first_name: "Andrea", last_name: "Verdi", nickname: "andreav", user: User.find(4) }
])

User.find(2).ask_friendship(User.find(1))
User.find(3).ask_friendship(User.find(1))
User.find(4).ask_friendship(User.find(1))
Friendship.last.confirm!
