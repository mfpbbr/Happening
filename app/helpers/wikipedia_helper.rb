require 'net/http'
require 'uri'

module WikipediaHelper
  WIKILOCATION_URI = "http://api.wikilocation.org/articles?lat=%f&lng=%f&limit=%d&radius=%d&type=%s"

  def fetch_objects_near_location(coordinates, 
                   options = { type: "landmark", limit: 30, radius: 20000 })

    @source_url = WIKILOCATION_URI % [ coordinates[1], coordinates[0], options[:limit], options[:radius], options[:type] ]
    uri = URI.parse(@source_url)
    
    response = Net::HTTP.get_response(uri)

    if response.code.to_i > 299
      logger.debug "URL: #{@source_url} responsecode: #{response.code} error:#{response.body.to_s}"
      return nil
    end

    return response.body
  end  

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
