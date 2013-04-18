class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
    @coordinates = current_geo_location
    @feed_items = user_signed_in? ? current_user.feed : []
  end

  def help
  end

  def about
  end

  def contact
  end
end
