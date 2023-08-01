# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# create user
user1 = User.create!(name: 'user1', email: 'user1@example.com', password: 'password')
user2 = User.create!(name: 'user2', email: 'user2@example.com', password: 'password')

# create team
team1 = Team.create!(name: 'Team 1', email: 'team1@example.com')
team2 = Team.create!(name: 'Team 2', email: 'team2@example.com')

# create stock
stock1 = Stock.create!(name: 'Stock 1', email: 'stock1@example.com')
stock2 = Stock.create!(name: 'Stock 2', email: 'stock2@example.com')
