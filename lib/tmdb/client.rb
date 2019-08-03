require 'open-uri'
require 'rubygems/package'
require 'zlib'

module TMDB
  API_BASE_PATH = "https://api.themoviedb.org/3".freeze

  module  Client
    def self.api_key
      Rails.application.secrets.tmdb_api_key
    end

    def self.api_base_path
      API_BASE_PATH
    end

    def self.search_movies(keyword)
      escaped_keyword = URI.escape(keyword)
      response_body = make_request("/search/movie", "query=#{escaped_keyword}&adult=false")
      response_hash = JSON.parse(response_body)["results"]

      movies = []
      response_hash.each do |movie|
        movies << {
          title: movie["title"],
          tmdb_code: movie["id"],
          poster_path: movie["poster_path"],
          year: movie["release_date"][0..3]
        }
      end
      movies
    end

    def self.get_movie_details(tmdb_code)
      response_body = make_request("/movie/#{tmdb_code}", "append_to_response=credits,videos")
      JSON.parse(response_body)
    end

    def self.get_updated_movies_ids
      date_string = (Date.today - 2).strftime('%d_%m_%Y') # Two days ago just to be safe
      source = open("http://files.tmdb.org/p/exports/movie_ids_#{date_string}.json.gz")
      result = Zlib::GzipReader.new(source).read
      serialized_movies_lines = result.split("\n")

      serialized_movies_lines
        .select { |line| line[1..13] == '"adult":false'}
        .map do |tmdb_movie|
          JSON.parse(tmdb_movie)["id"]
        end
    end

    def self.make_request(endpoint, query_string)
      url = "#{api_base_path}#{endpoint}?#{query_string}&api_key=#{api_key}"

      response = HTTParty.get(url)

      api_response_errors = JSON.parse(response.body)["status_message"]
      if response.code != 200 or api_response_errors
        raise TMDB::RequestError.new(api_response_errors)
      end

      response.body
    end
  end
end
