class AdaptiveTweetsApi
  class NotOkay < StandardError; end
  attr_reader :http

  # http library used is injectable for testing
  # defaults to HTTParty, review dependent API before using another library
  def initialize http_library=HTTParty
    @http = http_library
  end

  # returns an Array of tweets
  def fetch_more_tweets
    response = http.get(tweets_endpoint)

    if response.code != 200
      raise NotOkay.new(response)
    end

    # the HTTParty response looks like an Array
    return response
  end

  protected
  def tweets_endpoint
    APP_CONFIG['adaptive_tweets_endpoint']
  end
end