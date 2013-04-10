require 'json'

class LandmarksController < ApplicationController
  include WikipediaHelper
 
  def index
    @landmarks = Landmark.geo_near(@coordinates).max_distance(20).spherical

    if @landmarks.nil? or @landmarks.empty?
      data = fetch_objects_near_location(@coordinates)
      if data.nil?
        @landmarks = []
        return
      end

      data = JSON.parse(data)

      raw_object = Raw.create(data: data, source_url: @source_url)
      @landmarks = []
      landmark_objects = parse_data(data)
      landmark_objects.each do |landmark_object|
        landmark_object.raw_id = raw_object.id
        landmark_object.distance = haversine_distance(@coordinates, landmark_object.coordinates).round(2).to_s + " miles"
        landmark_object.save!
        @landmarks << landmark_object
      end
    else
      @landmarks.each do |landmark_object|
        landmark_object.distance = landmark_object.geo_near_distance.round(2).to_s + " miles"
      end
    end

  end

  def show
    @landmark = Landmark.find(params[:id])
    @landmark.distance = haversine_distance(@coordinates, @landmark.coordinates).round(2).to_s + " miles"
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
