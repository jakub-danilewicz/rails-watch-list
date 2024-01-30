# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"
require "json"


Movie.delete_all

# open("https://tmdb.lewagon.com/movie/top_rated") do |entries|
#   data = []
#   entries.read.each_line do |entry|
#     @item = JSON.parse(entry)
#       object = {
#     		"title":        @item["title"],
#     		"overview":     @item["overview"],
#     		"poster_url":   @item["file_url"]
#       }
#       data << object
#   end
#   Movie.create!(data)
# end


url = 'https://tmdb.lewagon.com/movie/top_rated'
response = URI.open(url).read
movies_data = JSON.parse(response)

movies_data['results'].first(20).each do |movie_data|
  movie = Movie.find_or_initialize_by(title: movie_data['title'])
  movie.update!(
    overview: movie_data['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500/#{movie_data['poster_path']}",
    rating: movie_data['vote_average']
  )

  puts "#{movie.title}"
end
