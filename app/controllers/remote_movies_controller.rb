class RemoteMoviesController < ApplicationController
  before_action :check_profile

  def index
    keyword = params[:search]
    tmdb_api_key = Rails.application.secrets.tmdb_api_key
    response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key="\
                            "#{tmdb_api_key}&query=#{keyword}&adult=false")

    @movies = []
    if response.code == 200
      response_hash = response.to_hash["results"]
      # TODO: use map here
      response_hash.each do |movie|
        @movies << { title: movie["title"], tmdb_code: movie["id"], poster_path: movie["poster_path"] }
      end
    end
  end
end
