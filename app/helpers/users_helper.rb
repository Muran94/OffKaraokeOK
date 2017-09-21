module UsersHelper
  def profile_image_url(user)
    return 'no_image_user.png' if user.blank? || user.image.blank?
    user.image.url
  end
end
