class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
    @coordinates = current_geo_location
    if user_signed_in?
      redirect_to photos_url
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
