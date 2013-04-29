require 'json'

class LandmarksController < ApplicationController
  include WikipediaHelper
 
  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @landmarks = Landmark.geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical

    @landmarks = create() if @landmarks.nil? or @landmarks.empty?
      
    @landmarks.each do |landmark_object|
        landmark_object.distance = haversine_distance(@coordinates, landmark_object.coordinates).round(2).to_s + " miles"
    end

  end

  def show
    @landmark = Landmark.find(params[:id])
    @landmark.distance = haversine_distance(@coordinates, @landmark.coordinates).round(2).to_s + " miles"
  end

  def create
    landmark_content = fetch_objects_near_location(@coordinates)
    if landmark_content.nil?
      @landmarks = []
    else
      data = JSON.parse(landmark_content)
      raw_object = Raw.create(data: data, source_url: @source_url)
      @landmarks = parse_data(data)
      @landmarks.each do |landmark|
        landmark.raw_id = raw_object.id
        landmark.save!
      end
    end

    return @landmarks
  end

end
