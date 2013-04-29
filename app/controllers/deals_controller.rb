require 'json'

class DealsController < ApplicationController
  include GrouponHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @deals = Deal.where(:created_at.gte => Time.now.utc - 1.hour).geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical.entries
    
    @deals = create() if @deals.nil? or @deals.empty? or @deals.count < 15

    if @deals.count < 10
      @deals.concat(Deal.geo_near(@coordinates).max_distance(convert_miles_to_radius(20)).spherical.entries)   
      @deals.uniq! { |deal| deal.url }
      @deals.sort_by! { |deal| deal.created_at }.reverse!
      @deals = @deals.take(20) 
    end 

    @deals.each do |deal|
      deal.distance = haversine_distance(@coordinates, deal.coordinates).round(2)
    end

    @distance_metric = "miles"
    @deals.sort_by! { |deal| deal.distance }
  end

  def show
    @deal = Deal.find(params[:id])
    @deal.distance = haversine_distance(@coordinates, @deal.coordinates).round(2)
    @distance_metric = "miles"
  end

  def create
    deal_content = fetch_objects_near_location(@coordinates)
    @deals = []

    unless deal_content.nil?
      deal_content = JSON.parse(deal_content)
      raw_object = Raw.create(data: deal_content, source_url: @source_url)
      deals_array = parse_data(deal_content)
      deals_array.each do |deal|
        existing_deal = Deal.where(url: deal.url).first
        if existing_deal.nil?
          deal.raw_id = raw_object.id
          deal.save!
          @deals << deal
        else
          @deals << existing_deal
        end
      end
    end

    return @deals
  end

end
