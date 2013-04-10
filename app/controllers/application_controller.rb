class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

    def current_geo_location
      if (!cookies[:geolocation_error].nil? and
        !cookies[:geolocation_error].empty?) or
        cookies[:lat_lng].nil?
        get_location_from_geocoder
      end
      return cookies[:lat_lng].split("|")      
    end

  private

    def get_location_from_geocoder
      # TODO: make call to geocoder
      # currently hardcoding this
      cookies[:lat_lng] = "37.401290|-122.017164"
    end
end
