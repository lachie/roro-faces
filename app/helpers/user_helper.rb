module UserHelper
  def user_link(user)
    if user
      link_to user.name_with_fallback, user_url(user)
    end
  end
end
