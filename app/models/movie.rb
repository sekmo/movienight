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

  def self.find_or_create_by_tmdb_id(tmdb_id)
    find_by(tmdb_code: tmdb_id) || create_from_tmdb(tmdb_id)
  end

  def self.create_from_tmdb(tmdb_id)
    movie_details = TMDB::Client.get_movie_details(tmdb_id)
    Movie.create!(
      {
        tmdb_code: movie_details["id"],
        title: movie_details["title"],
        poster_path: movie_details["poster_path"],
        length: movie_details["runtime"],
        rating: movie_details["vote_average"],
        year: movie_details["release_date"][0..3].to_i,
        directors: movie_details["credits"]["crew"]
          .select { |person| person["job"] == "Director" }
          .map { |person| person["name"] }.sort
      }
    )
  end

  # def self.sync_from_tmdb
  #   puts "XXX Started! #{DateTime.now  }"
  #   stored_tmdb_ids = Movie.all.pluck(:tmdb_code)
  #   all_updated_tmdb_ids = TMDB::Client.get_updated_movies_ids
  #   ids_to_sync = all_updated_tmdb_ids - stored_tmdb_ids
  #
  #   ids_to_sync.each_slice(40) do |ids_to_sync_grouped|
  #     time = Time.now
  #
  #     ids_to_sync_grouped.each do |tmdb_id|
  #       begin
  #         # MovieSyncJob.perform_later(tmdb_id)
  #         Movie.create_from_tmdb(tmdb_id)
  #       rescue TMDB::RequestError => e
  #         Rails.logger.info("XXX Error with tmdb_id #{tmdb_id} - #{e.message}")
  #       end
  #     end
  #
  #     seconds_elapsed = Time.now - time
  #     Rails.logger.info("seconds_elapsed: #{seconds_elapsed}")
  #     if seconds_elapsed < 10
  #       Rails.logger.info("sleeping for #{10 - seconds_elapsed}")
  #       sleep(10 - seconds_elapsed)
  #     end
  #
  #   puts "XXX Finished! #{DateTime.now}"
  #   end
  # end
end
