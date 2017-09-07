class RemoteMoviesController < ApplicationController
  def index
    keyword = params[:search]
    response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=#{Rails.application.secrets.tmdb_api_key}&query=#{keyword}&adult=false")

    @movies = []
    if response.code == 200
      response_hash = response.to_hash["results"]
      response_hash.each do |movie|
        @movies << { title: movie["title"], tmdb_id: movie["id"], poster_path: movie["poster_path"] }
      end
    end

  end
end
