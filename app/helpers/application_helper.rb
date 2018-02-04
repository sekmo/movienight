module ApplicationHelper
  def movie_poster_image(tmdb_movie_poster_path)
    if tmdb_movie_poster_path.present?
      image_tag("http://image.tmdb.org/t/p/w185/#{tmdb_movie_poster_path}")
    else
      image_tag("poster-placeholder.png")
    end
  end

  def flash_class(level)
    case level
      when "success" then "alert alert-success"
      when "notice" then "alert alert-info"
      when "alert" then "alert alert-warning"
      when "error" then "alert alert-danger"
    end
  end
end
