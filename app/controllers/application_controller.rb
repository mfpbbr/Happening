class ApplicationController < ActionController::Base
  protect_from_forgery
  include GeoHelper
  before_filter :current_geo_location
  before_filter :authenticate_user!

  protected

    def current_geo_location
      if (!cookies[:geolocation_error].nil? and
        !cookies[:geolocation_error].empty?) or
        cookies[:lng_lat].nil?
        get_location_from_geocoder
      end
      @coordinates = cookies[:lng_lat].split("|").map { |str| str.to_f }
    end

  private

    def get_location_from_geocoder
      cookies[:lng_lat] = "#{request.location.longitude}|#{request.location.latitude}"
    end
end
