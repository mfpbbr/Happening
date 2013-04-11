require 'oauth'
require 'uri'

module YelpHelper
  YELP_URI_HOST = "http://api.yelp.com"
  YELP_URI_PATH = "/v2/search?ll=%f,%f&limit=%d&radius_filter=%d&category_filter=%s"
  YELP_CONSUMER_KEY = ENV['YELP_CONSUMER_KEY']
  YELP_CONSUMER_SECRET = ENV['YELP_CONSUMER_SECRET']
  YELP_TOKEN = ENV['YELP_TOKEN']
  YELP_TOKEN_SECRET = ENV['YELP_TOKEN_SECRET']

  def fetch_objects_near_location(coordinates, categories,
                   options = { limit: 20, radius: 20000 })

    source_url_path = YELP_URI_PATH % [ coordinates[1], coordinates[0], options[:limit], options[:radius], categories ]
    @source_url = YELP_URI_HOST + source_url_path

    consumer = OAuth::Consumer.new(YELP_CONSUMER_KEY, YELP_CONSUMER_SECRET, {site: YELP_URI_HOST})
    access_token = OAuth::AccessToken.new(consumer, YELP_TOKEN, YELP_TOKEN_SECRET)

    response = access_token.get(source_url_path)

    if response.code.to_i > 299
      logger.debug "URL: #{@source_url} responsecode: #{response.code} error:#{response.body.to_s}"
      return nil
    end

    return response.body
  end  
end
