require 'net/http'
require 'uri'

module GrouponHelper
  GROUPON_API_KEY = ENV['GROUPON_API_KEY']
  GROUPON_URI = "https://api.groupon.com/v2/deals.json?client_id=#{GROUPON_API_KEY}&lat=%f&lng=%f&radius=%d"

  def fetch_objects_near_location(coordinates, options = { radius: 20 })
    @source_url = GROUPON_URI % [ coordinates[1], coordinates[0], options[:radius] ]
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
    deal_objects = []

    data["deals"].each do |deal_details|
      redemption = deal_details["options"][0]["redemptionLocations"][0]
      address = nil
      unless redemption.nil?
        address = redemption["streetAddress1"] 
        address += " , " + redemption["city"] 
        address += " , " + redemption["state"] 
        address += " - " + redemption["postalCode"] 
        address += " , " + redemption["country"]
      end

      deal = Deal.new(
                    coordinates: [ deal_details["division"]["lng"], deal_details["division"]["lat"] ],
                    title: deal_details["title"], 
                    url: deal_details["dealUrl"],
                    merchant_name: deal_details["merchant"]["name"],
                    address: address,
                    image_small: deal_details["grid4ImageUrl"],
                    image_large: deal_details["largeImageUrl"],
                    source: "groupon")

      deal_objects << deal
    end 

    return deal_objects
  end
end
