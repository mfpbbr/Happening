module ApplicationHelper
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? "active" : ""

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end

  def entity_link(link_text, link_path)
    if link_text =~ %r{\Ahttps?://.+\.(?:jpe?g|png|gif)\z}i
      link_to image_tag(link_text), link_path
    else
      link_to link_text, link_path
    end
  end
end
