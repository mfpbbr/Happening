require 'json'

class RestaurantsController < ApplicationController
  include YelpHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @restaurants = Restaurant.geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical

    @restaurants = create() if @restaurants.nil? or @restaurants.empty?

    @restaurants.each do |restaurant|
      restaurant.distance = haversine_distance(@coordinates, restaurant.coordinates).round(2).to_s + " miles"
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @restaurant.distance = haversine_distance(@coordinates, @restaurant.coordinates).round(2).to_s + " miles"
  end

  def create
    data = fetch_objects_near_location(@coordinates, "restaurants")
    if data.nil?
      @restaurants = []
    else
      data = JSON.parse(data)
      raw_object = Raw.create(data: data, source_url: @source_url)
      @restaurants = parse_data(data, "restaurant")
      @restaurants.each do |restaurant|
        restaurant.raw_id = raw_object.id
        restaurant.save!
      end
    end

    return @restaurants
  end

end
