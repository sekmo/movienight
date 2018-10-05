class TMDB::RequestError < StandardError
  attr_reader :message

  def initialize(message)
   super
   @message = message
  end
end

class Client
  attr_reader :api_key
  API_BASE_PATH = "https://api.themoviedb.org/3"

  def initialize(api_key)
    @api_key = api_key
  end

  def search_movies(keyword)
    response_body = make_request("/search/movie", "query=#{keyword}&adult=false")
    movies = []
    response_hash = JSON.parse(response_body)["results"]

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
