require 'json'

class EventsController < ApplicationController
  include EventbriteHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @events = Event.where(:created_at.gte => Time.now.utc - 1.hour).geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical.entries
    
    @events = create() if @events.nil? or @events.empty? or @events.count < 15

    if @events.count < 10
      @events.concat(Event.geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical.entries)   
      @events.uniq! { |event| event.url }
      @events.sort_by! { |event| event.created_at }.reverse!
      @events = @events.take(20) 
    end

    @events.each do |event|
      event.distance = haversine_distance(@coordinates, event.coordinates).round(2)
    end

    @distance_metric = "miles"
    @events.sort_by! { |event| event.distance } 
  end

  def show
    @event = Event.find(params[:id])
    @event.distance = haversine_distance(@coordinates, @event.coordinates).round(2)
    @distance_metric = "miles"
  end

  def create
    event_content = fetch_objects_near_location(@coordinates, "music")
    @events = []

    unless event_content.nil?
      event_content = JSON.parse(event_content)
      raw_object = Raw.create(data: event_content, source_url: @source_url)
      events_array = parse_data(event_content)
      events_array.each do |event|
        existing_event = Event.where(url: event.url).first
        if existing_event.nil?
          event.raw_id = raw_object.id
          event.save!
          @events << event
        else
          @events << existing_event
        end
      end
    end

    return @events
  end

end
