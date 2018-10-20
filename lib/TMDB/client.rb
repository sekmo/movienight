module TMDB
  class Client
    attr_reader :api_key
    API_BASE_PATH = "https://api.themoviedb.org/3"

    def initialize(api_key)
      @api_key = api_key
    end

    def search_movies(keyword)
      response_body = make_request("/search/movie", "query=#{keyword}&adult=false")
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

    def get_movie_details(tmdb_code)
      response_body = make_request("/movie/#{tmdb_code}", "append_to_response=credits,videos")
      JSON.parse(response_body)
    end

    def make_request(endpoint, query_string)
      url = "#{API_BASE_PATH}#{endpoint}?#{query_string}&api_key=#{@api_key}"
      response = HTTParty.get(url)

      api_response_errors = JSON.parse(response.body)["errors"]
      if response.code != 200 or api_response_errors
        raise TMDB::RequestError.new(api_response_errors)
      end

      response.body
    end
  end
end
