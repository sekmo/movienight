module TMDB
  module  Client
    def self.api_key
      Rails.application.secrets.tmdb_api_key
    end

    def self.api_base_path
      "https://api.themoviedb.org/3"
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
          length: movie
        }
      end
      movies
    end

    def self.get_movie_details(tmdb_code)
      response_body = make_request("/movie/#{tmdb_code}", "append_to_response=credits,videos")
      JSON.parse(response_body)
    end

    def self.make_request(endpoint, query_string)
      url = "#{api_base_path}#{endpoint}?#{query_string}&api_key=#{api_key}"
      response = HTTParty.get(url)

      api_response_errors = JSON.parse(response.body)["errors"]
      if response.code != 200 or api_response_errors
        raise TMDB::RequestError.new(api_response_errors)
      end

      response.body
    end
  end
end
