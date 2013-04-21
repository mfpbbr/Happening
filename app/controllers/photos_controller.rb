require 'json'

class PhotosController < ApplicationController
  include InstagramHelper
  #include FlickrHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @photos = Photo.where(:created_at.gte => Time.now.utc - 1.hour).geo_near(@coordinates).max_distance(20).spherical.entries
    
    @photos = create() if @photos.nil? or @photos.empty? or @photos.count < 15
    if @photos.count < 10
      @photos.concat(Photo.geo_near(@coordinates).max_distance(20).spherical.entries)
      @photos.uniq! { |photo| photo.url }
      @photos.sort_by! { |photo| photo.created_at }.reverse!
      @photos = @photos.take(20)
    end 

    @photos.each do |photo|
      photo.distance = haversine_distance(@coordinates, photo.coordinates).round(2)
    end

    @distance_metric = "miles"
    @photos.sort_by! { |photo| photo.distance }
  end

  def show
    @photo = Photo.find(params[:id])
    @photo.distance = haversine_distance(@coordinates, @photo.coordinates).round(2).to_s
    @distance_metric = "miles"
  end

  def create
    photo_content = fetch_objects_near_location(@coordinates)
    @photos = []

    unless photo_content.nil?
      photo_content = JSON.parse(photo_content)
      raw_object = Raw.create(data: photo_content, source_url: @source_url)
      photos_array = parse_data(photo_content)
      photos_array.each do |photo|
        existing_photo = Photo.where(url: photo.url).first
        if existing_photo.nil?
          photo.raw_id = raw_object.id
          photo.save!
          @photos << photo
        else
          @photos << existing_photo
        end
      end
    end

    return @photos
  end

end
