class AdaptiveTweetsApi
  attr_reader :http

  def initialize http_library=HTTParty
    @http = http_library
  end

  def fetch_more_tweets
    http.get(tweets_endpoint)
  end

  protected
  def tweets_endpoint
    APP_CONFIG['adaptive_tweets_endpoint']
  end
end