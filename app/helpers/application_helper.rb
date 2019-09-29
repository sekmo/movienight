module ApplicationHelper
  def error_messages_for(object)
    render(partial: "shared/error_messages", locals: {object: object})
  end

  def movie_poster_image(poster_path, html_class = nil)
    image_path = poster_path(poster_path)
    image_tag(image_path, class: html_class)
  end

  def poster_path(poster_path)
    if poster_path.present?
      "https://image.tmdb.org/t/p/w342/#{poster_path}"
    else
      image_url("poster-placeholder.png")
    end
  end

  def flash_class(level)
    case level
      when "success" then "alert alert-success"
      when "alert" then "alert alert-warning"
      when "error" then "alert alert-danger"
      else "alert alert-info"
    end
  end
end
