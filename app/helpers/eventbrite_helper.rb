require 'net/http'
require 'uri'

module EventbriteHelper
  EVENTBRITE_API_KEY = ENV['EVENTBRITE_API_KEY']
  EVENTBRITE_SEARCH_URI = "https://www.eventbrite.com/json/event_search?app_key=#{EVENTBRITE_API_KEY}&category=%s&within=%d&max=%d&latitude=%f&longitude=%f"

  def fetch_objects_near_location(coordinates, category, options = { limit: 20, radius: 20 })

    @source_url = EVENTBRITE_SEARCH_URI % [ category, options[:radius], options[:limit], coordinates[1], coordinates[0] ]
    uri = URI.parse(@source_url)
   
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.get(uri.request_uri)

    if response.code.to_i > 299
      logger.debug "URL: #{@source_url} responsecode: #{response.code} error:#{response.body.to_s}"
      return nil
    end

    return response.body
  end  

  def parse_data(data)
    event_objects = []

    data["events"].each do |event_details|
      next if event_details["event"].nil? 
      lat_lng = event_details["event"]["venue"]["Lat-Long"].split("/")
      latitude = lat_lng[0].strip.to_f
      longitude = lat_lng[1].strip.to_f
      venue = event_details["event"]["venue"]
      address = venue["address"] + ", " + venue["city"] + " - " + venue["postal_code"] + " " + venue["region"] + " " + venue["country"]

     event =  Event.new(
                coordinates: [longitude, latitude],
                title: event_details["event"]["title"],
                url: event_details["event"]["url"],
                venue_name: venue["name"],
                address: address,
                start_date: event_details["event"]["start_date"],
                source: "eventbrite")

      event_objects << event
    end

    return event_objects
  end
end
