require 'json'

class EventsController < ApplicationController
  include EventbriteHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @events = Event.geo_near(@coordinates).max_distance(20).spherical
    
    @events = create() if @events.nil? or @events.empty?

    @events.each do |event|
      event.distance = haversine_distance(@coordinates, event.coordinates).round(2).to_s + " miles"
    end
  end

  def show
    @event = Event.find(params[:id])
    @event.distance = haversine_distance(@coordinates, @event.coordinates).round(2).to_s + " miles"
  end

  def create
    event_content = fetch_objects_near_location(@coordinates, "music")

    if event_content.nil?
      @events = []
    else
      event_content = JSON.parse(event_content)
      raw_object = Raw.create(data: event_content, source_url: @source_url)
      @events = parse_data(event_content)
      @events.each do |event|
        event.raw_id = raw_object.id
        event.save!
      end
    end

    return @events
  end

end
