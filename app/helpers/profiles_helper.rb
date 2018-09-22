module ProfilesHelper
  def profile_image_for(profile, class_name = "profile__picture")
    if profile.image.present?
       image_tag profile.image_url, class: class_name
     else
       tag.div profile.initials, class: "#{class_name}--placeholder"
    end
  end
end
