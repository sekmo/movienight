class Movie < ApplicationRecord
  has_many :wishes, dependent: :destroy
  has_many :users, through: :wishes

  validates :tmdb_code, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true

  # Return all the movies that are in all the watchlists of every specified user
  def self.match_all_users(users_ids)
    # It returns two arrays: the first with the 100% matching movies, the second with the
    # partially matching movies
    # {
    #   complete_match: [ movie1, movie2 ],
    #   partial_match: [ movie3, movie4, movie5 ],
    # }
    Movie.select("id","title","poster_path", "rating", "count(1) as matching_users", "#{users_ids.size} as total_matched_users", "round((count(1)::numeric/#{users_ids.size}*100))::integer as matching_percentage")
    .joins(:users)
    .where(users: {id: users_ids})
    .order(count: :desc, rating: :desc)
    .group(:id)
    .partition {|movie| movie.matching_percentage == 100}
    .map.with_index {|arr,i| [ i == 0 ? :complete_match : :partial_match, arr]}
    .to_h
  end

  def self.create_from_tmdb_id(tmdb_id, force_update: false)
    movie_details = TMDB::Client.get_movie_details(tmdb_id)
    movie_params = {
      tmdb_code: movie_details["id"],
      title: movie_details["title"],
      original_title: movie_details["original_title"],
      plot: movie_details["overview"],
      poster_path: movie_details["poster_path"],
      length: movie_details["runtime"],
      rating: movie_details["vote_average"],
      year: movie_details["release_date"][0..3].to_i,
      directors: movie_details["credits"]["crew"]
        .select { |person| person["job"] == "Director" }
        .map { |person| person["name"] }.sort
    }

    persisted_movie = Movie.find_by(tmdb_code: tmdb_id)
    
    if persisted_movie
      persisted_movie.update!(movie_params) if force_update
    else
      Movie.create!(movie_params)
    end
  end

  def self.search_by_title(keyword)
    Movie.where("title ILIKE ?", "%#{keyword}%").order(rating: :desc).limit(20)
  end
end
