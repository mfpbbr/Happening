require 'net/http'
require 'uri'
require 'json'

module FlickrHelper
  FLICKR_API_KEY = ENV['FLICKR_API_KEY']
  FLICKR_SEARCH_URI = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{FLICKR_API_KEY}&lat=%f&lon=%f&radius=%d&radius_units=mi&per_page=%d&sort=relevance&format=json&nojsoncallback=1"
  FLICKR_PHOTO_INFO_URI = "http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=#{FLICKR_API_KEY}&photo_id=%s&secret=%s&format=json&nojsoncallback=1"

  def fetch_objects_near_location(coordinates, options = { limit: 20, radius: 20 })

    @source_url = FLICKR_SEARCH_URI % [ coordinates[1], coordinates[0], options[:radius], options[:limit] ]
    uri = URI.parse(@source_url)
    
    response = Net::HTTP.get_response(uri)

    if response.code.to_i > 299
      logger.debug "URL: #{@source_url} responsecode: #{response.code} error:#{response.body.to_s}"
      return nil
    end

    return response.body
  end  

  def parse_data(data)
    photo_objects = []

    data["photos"]["photo"].each do |image_details|
      
      photo = get_single_photo_object(image_details)

      photo_objects << photo unless photo.nil?
    end

    return photo_objects
  end

  private

    def get_single_photo_object(image_details)
      photo_id = image_details["id"]
      secret = image_details["secret"]
      server_id = image_details["server"]
      farm_id = image_details["farm"]
      photo_image_small = "http://farm#{farm_id}.staticflickr.com/#{server_id}/#{photo_id}_#{secret}_t.jpg"
      photo_image_large = "http://farm#{farm_id}.staticflickr.com/#{server_id}/#{photo_id}_#{secret}_b.jpg"
      
      photo_info_url = FLICKR_PHOTO_INFO_URI % [ photo_id, secret ]
      uri = URI.parse(photo_info_url)
      response = Net::HTTP.get_response(uri)
    
      if response.code.to_i > 299
        logger.debug "URL: #{photo_info_url} responsecode: #{response.code} error:#{response.body.to_s}"
        return nil
      end
     
      data = JSON.parse(response.body)
      
      location_name = data["photo"]["location"]["neighbourhood"]
      location_name = data["photo"]["location"]["locality"] if location_name.nil?
      location_name = location_name["_content"] unless location_name.nil?
      
      return Photo.new(
                coordinates: [data["photo"]["location"]["longitude"], data["photo"]["location"]["latitude"]],
                title: data["photo"]["title"]["_content"],
                url: data["photo"]["urls"]["url"][0]["_content"],
                location_name: location_name,
                image_small: photo_image_small,
                image_large: photo_image_large,
                source: "flickr")
    end
end
