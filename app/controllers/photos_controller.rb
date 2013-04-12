require 'json'

class PhotosController < ApplicationController
  #include InstagramHelper
  include FlickrHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @photos = Photo.geo_near(@coordinates).max_distance(20).spherical
    
    @photos = create() if @photos.nil? or @photos.empty?

    @photos.each do |photo|
      photo.distance = haversine_distance(@coordinates, photo.coordinates).round(2).to_s + " miles"
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @photo.distance = haversine_distance(@coordinates, @photo.coordinates).round(2).to_s + " miles"
  end

  def create
    photo_content = fetch_objects_near_location(@coordinates)

    if photo_content.nil?
      @photos = []
    else
      photo_content = JSON.parse(photo_content)
      raw_object = Raw.create(data: photo_content, source_url: @source_url)
      @photos = parse_data(photo_content)
      @photos.each do |photo|
        photo.raw_id = raw_object.id
        photo.save!
      end
    end

    return @photos
  end

end
