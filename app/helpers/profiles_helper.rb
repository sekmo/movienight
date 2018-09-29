module ProfilesHelper
  def profile_image_for(profile, class_name = "profile__picture")
    if profile.image.present?
      "<div class=\"#{class_name}\" style=\"background: url(#{profile.image_url})\"></div>".html_safe
    else
      tag.div profile.initials, class: "#{class_name}--placeholder"
    end
  end
end
