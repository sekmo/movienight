module ApplicationHelper
  def error_messages_for(object)
    render(partial: "shared/error_messages", locals: {object: object})
  end

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
      when "alert" then "alert alert-warning"
      when "error" then "alert alert-danger"
      else "alert alert-info"
    end
  end

  def current_user_has_profile?
    current_user.profile.try(:persisted?)
  end

  def current_user_profile
    @_current_user_profile ||= current_user.profile
  end
end
