class PopulateMoviesWithAdditionalData < ActiveRecord::Migration[5.1]
  def change
    batch_size = 10
    movies_amount = Movie.count
    batches_amount = (movies_amount / batch_size.to_f).ceil

    Movie.find_in_batches(batch_size: batch_size).with_index do |group, batch|
      say_with_time("Updated batch #{(batch + 1)}/#{batches_amount}") do
        group.each do |movie|
          movie_details = TMDB::Client.get_movie_details(movie.tmdb_code)
          movie.update!(
            title: movie_details["title"],
            poster_path: movie_details["poster_path"],
            length: movie_details["runtime"],
            rating: movie_details["vote_average"],
            year: movie_details["release_date"][0..3].to_i,
            directors: movie_details["credits"]["crew"]
              .select { |person| person["job"] == "Director" }
              .map { |person| person["name"] }.sort
          )
        end
      end
    end
  end
end
