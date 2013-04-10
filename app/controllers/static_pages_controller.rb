class StaticPagesController < ApplicationController
  def home
    @coordinates = current_geo_location
  end

  def help
  end

  def about
  end

  def contact
  end
end
