require 'net/http'
require 'uri'

module InstagramHelper
  INSTAGRAM_CLIENT_ID = ENV['INSTAGRAM_CLIENT_ID']
  INSTAGRAM_URI = "https://api.instagram.com/v1/media/search?client_id=#{INSTAGRAM_CLIENT_ID}&lat=%f&lng=%f&distance=%d"

  def fetch_objects_near_location(coordinates, options = { radius: 5000 })
    @source_url = INSTAGRAM_URI % [ coordinates[1], coordinates[0], options[:radius] ]
    uri = URI.parse(@source_url)
    
    req = Net::HTTP::Get.new(uri.path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(req)

    if response.code.to_i > 299
      logger.debug "URL: #{@source_url} responsecode: #{response.code} error:#{response.body.to_s}"
      return nil
    end

    return response.body
  end  

  def parse_data(data)
    photo_objects = []

    data["data"].each do |image|
      photo = Photo.new(
                    coordinates: [image["location"]["longitude"], image["location"]["latitude"]],
                    title: image["caption"], 
                    url: image["link"],
                    location_name: image["location"]["name"],
                    image_small: image["images"]["thumbnail"]["url"],
                    image_large: image["images"]["standard_resolution"]["url"],
                    source: "instagram")

      photo_objects << photo
    end 

    return photo_objects
  end
end
