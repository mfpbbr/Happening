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
      logger.debug "URL: #{urlstring} responsecode: #{response.code}"
      return nil
    end

    return response.body
  end  
end
