class Movie < ApplicationRecord
  has_many :wishes, dependent: :destroy
  has_many :profiles, through: :wishes

  validates :tmdb_code, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true

  # Return all the movies that are in all the watchlists of every specified profile
  def self.match_all_profiles(profile_ids)
    Movie.joins(:profiles).where(profiles: {id: profile_ids}).group(:id).having("COUNT(*) = ?", profile_ids.size)
  end

  def self.find_or_create_by_tmdb_id(tmdb_id)
    #TODO Don't do an api request if the movie is persisted
    movie_details = TMDB::Client.get_movie_details(tmdb_id)

    Movie.create_with(
      title: movie_details["title"],
      poster_path: movie_details["poster_path"],
      length: movie_details["runtime"],
      rating: movie_details["vote_average"],
      year: movie_details["release_date"][0..3].to_i,
      directors: movie_details["credits"]["crew"]
        .select { |person| person["job"] == "Director" }
        .map { |person| person["name"] }
    ).find_or_create_by!(tmdb_code: tmdb_id)
  end
end
