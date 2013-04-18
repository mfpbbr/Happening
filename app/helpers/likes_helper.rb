module LikesHelper
  def find_like(user, likeable)
    return likeable.likes.where(user_id: user.id).first
  end

  def generate_css_id(likeable)
    return "#{likeable.class}_#{likeable.id}"
  end
end
