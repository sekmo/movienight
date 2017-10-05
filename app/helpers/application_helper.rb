module ApplicationHelper
  def movie_poster_image(tmdb_movie_poster_path)
    if tmdb_movie_poster_path.present?
      image_tag("http://image.tmdb.org/t/p/w185/#{tmdb_movie_poster_path}")
    else
      image_tag("poster-placeholder.png")
    end
  end
end
