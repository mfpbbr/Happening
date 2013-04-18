module LikesHelper
  def find_like(user, likeable)
    begin
      result_array = Like.where(user_id: user.id, likeable_id: likeable.id, likeable_type: likeable.class.to_s)
    rescue
      result_array = nil
    end

    return nil if result_array.nil? or result_array.empty?
    return result_array.first
  end

  def generate_css_id(likeable)
    return "#{likeable.class}_#{likeable.id}"
  end
end
