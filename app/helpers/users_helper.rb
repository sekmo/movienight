module UsersHelper
  def profile_image_for(user, class_name = "profile-picture")
    tag.div class: "#{class_name}" do
      concat(tag.div user.initials, class: "#{class_name}--placeholder")
      concat("<div class=\"#{class_name}--image\" style=\"background: url(#{user.image_url})\"></div>".html_safe)
    end
  end
end
