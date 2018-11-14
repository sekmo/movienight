class Movie < ApplicationRecord
  has_many :wishes, dependent: :destroy
  has_many :profiles, through: :wishes

  validates :tmdb_code, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true

  # Return all the movies that are in all the watchlists of every specified profile
  # def self.match_all_profiles(profile_ids)
  #   Movie.joins(:profiles).where(profiles: {id: profile_ids}).group(:id).having("COUNT(*) = ?", profile_ids.size)
  # end

  def self.match_all_profiles(profile_ids)
    # It returns two arrays: the first with the 100% matching movies, the second with the
    # partially matching movies
    # {
    #   complete_match: [ movie1, movie2 ],
    #   partial_match: [ movie3, movie4, movie5 ],
    # }
    Movie.select("id","title","poster_path", "rating", "round((count(1)::numeric/#{profile_ids.size}*100))::integer as matching_percentage")
    .joins(:profiles)
    .where(profiles: {id: profile_ids})
    .order(count: :desc, rating: :desc)
    .group(:id)
    .partition {|movie| movie.matching_percentage == 100}
    .map.with_index {|arr,i| [ i == 0 ? :complete_match : :partial_match, arr]}
    .to_h
  end

  def self.find_or_create_by_tmdb_id(tmdb_id)
    Movie.find_or_create_by!(tmdb_code: tmdb_id) do |movie|
      movie_details = TMDB::Client.get_movie_details(tmdb_id)
      movie.title = movie_details["title"]
      movie.poster_path = movie_details["poster_path"]
      movie.length = movie_details["runtime"]
      movie.rating = movie_details["vote_average"]
      movie.year = movie_details["release_date"][0..3].to_i
      movie.directors = movie_details["credits"]["crew"]
        .select { |person| person["job"] == "Director" }
        .map { |person| person["name"] }.sort
    end
  end
end
