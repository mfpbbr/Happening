require 'json'

class DealsController < ApplicationController
  include GrouponHelper

  def index
    # NOTE: There is a difference between the geo_near_distance 
    # returned by mongoid and the haversine distance i compute
    @deals = Deal.geo_near(@coordinates).max_distance(20).spherical
    
    @deals = create() if @deals.nil? or @deals.empty?

    @deals.each do |deal|
      deal.distance = haversine_distance(@coordinates, deal.coordinates).round(2).to_s + " miles"
    end
  end

  def show
    @deal = Deal.find(params[:id])
    @deal.distance = haversine_distance(@coordinates, @deal.coordinates).round(2).to_s + " miles"
  end

  def create
    deal_content = fetch_objects_near_location(@coordinates)

    if deal_content.nil?
      @deals = []
    else
      deal_content = JSON.parse(deal_content)
      raw_object = Raw.create(data: deal_content, source_url: @source_url)
      @deals = parse_data(deal_content)
      @deals.each do |deal|
        deal.raw_id = raw_object.id
        deal.save!
      end
    end

    return @deals
  end

end
