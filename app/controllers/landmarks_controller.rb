require 'json'

class LandmarksController < ApplicationController
  include WikipediaHelper
 
  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @landmarks = Landmark.geo_near(@coordinates).max_distance(20).spherical

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
    data = fetch_objects_near_location(@coordinates)
    if data.nil?
      @landmarks = []
      return @landmarks
    end

    data = JSON.parse(data)

    raw_object = Raw.create(data: data, source_url: @source_url)
    @landmarks = []
    landmark_objects = parse_data(data)
    landmark_objects.each do |landmark_object|
      landmark_object.raw_id = raw_object.id
      landmark_object.save!
      @landmarks << landmark_object
    end

    return @landmarks
  end

  private

    def parse_data(data)
      landmark_objects = []

      data["articles"].each do |article|
        landmark_object = Landmark.new(
                    coordinates: [article["lng"].to_f, article["lat"].to_f],
                      title: article["title"], 
                      url: article["url"],
                      source: "wikipedia")

        landmark_objects << landmark_object
      end 

      return landmark_objects
    end
end
