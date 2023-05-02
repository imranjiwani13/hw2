# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!

# Rubric
# 
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)

# Submission
# 
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
# TODO!

# Generate models and tables, according to the domain model.
# TODO!

# Insert data into the database that reflects the sample data shown above.
# Do not use hard-coded foreign key IDs.
# TODO!

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
# TODO!

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
# TODO!


rails new movie_database

cd movie_database

rails generate model Studio name:string
rails generate model Movie title:string year_released:integer rated:string studio:references
rails generate model Actor name:string
rails generate model Role movie:references actor:references character_name:string

rails db:migrate

class Studio < ApplicationRecord
    has_many :movies
  end


class Movie < ApplicationRecord
    belongs_to :studio
    has_many :roles
    has_many :actors, through: :roles
  end

class Actor < ApplicationRecord
    has_many :roles
    has_many :movies, through: :roles
  end
  
class Role < ApplicationRecord
    belongs_to :movie
    belongs_to :actor
  end
  

# Destroy existing data
Studio.destroy_all
Actor.destroy_all
Movie.destroy_all
Role.destroy_all

# Create Studio
studio = Studio.create!(name: "Warner Bros.")

# Create Movies
batman_begins = studio.movies.create!(title: "Batman Begins", year_released: 2005, rated: "PG-13")
the_dark_knight = studio.movies.create!(title: "The Dark Knight", year_released: 2008, rated: "PG-13")
the_dark_knight_rises = studio.movies.create!(title: "The Dark Knight Rises", year_released: 2012, rated: "PG-13")

# Create Actors
christian_bale = Actor.create!(name: "Christian Bale")
michael_caine = Actor.create!(name: "Michael Caine")
liam_neeson = Actor.create!(name: "Liam Neeson")
katie_holmes = Actor.create!(name: "Katie Holmes")
gary_oldman = Actor.create!(name: "Gary Oldman")
heath_ledger = Actor.create!(name: "Heath Ledger")
aaron_eckhart = Actor.create!(name: "Aaron Eckhart")
maggie_gyllenhaal = Actor.create!(name: "Maggie Gyllenhaal")
tom_hardy = Actor.create!(name: "Tom Hardy")
joseph_gordon_levitt = Actor.create!(name: "Joseph Gordon-Levitt")
anne_hathaway = Actor.create!(name: "Anne Hathaway")

# Create Roles
batman_begins.roles.create!([{ actor: christian_bale, character_name: "Bruce Wayne" },
                             { actor: michael_caine, character_name: "Alfred" },
                             { actor: liam_neeson, character_name: "Ra's Al Ghul" },
                             { actor: katie_holmes, character_name: "Rachel Dawes" },
                             { actor: gary_oldman, character_name: "Commissioner Gordon" }])

the_dark_knight.roles.create!([{ actor: christian_bale, character_name: "Bruce Wayne" },
                               { actor: heath_ledger, character_name: "Joker" },
                               { actor: aaron_eckhart, character_name: "Harvey Dent" },
                               { actor: michael_caine, character_name: "Alfred" },
                               { actor: maggie_gyllenhaal, character_name: "Rachel Dawes" }])

the_dark_knight_rises.roles.create!([{ actor: christian_bale, character_name: "Bruce Wayne" },
                                      { actor: gary_oldman, character_name: "Commissioner Gordon" },
                                      { actor: tom_hardy, character_name: "Bane" },
                                      { actor: joseph_gordon_levitt, character_name: "John Blake" },
                                      { actor: anne_hathaway, character_name: "Selina Kyle" }])



# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
movies = Movie.joins(:studio).select('movies.*, studios.name AS studio_name')
movies.each do |movie|
  puts "#{movie.title} (#{movie.year_released}) - Rated: #{movie.rated} - Studio: #{movie.studio_name}"
end

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
roles = Role.joins(:movie, :actor).select('roles.*, movies.title AS movie_title, actors.name AS actor_name')
roles.each do |role|
  puts "#{role.movie_title}: #{role.actor_name} as #{role.character_name}"
end
