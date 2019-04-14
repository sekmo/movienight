module UsersHelper
  def profile_image_for(user, class_name = "profile__picture")
    if user.image.present?
      "<div class=\"#{class_name}\" style=\"background: url(#{user.image_url})\"></div>".html_safe
    else
      tag.div user.initials, class: "#{class_name}--placeholder"
    end
  end
end
