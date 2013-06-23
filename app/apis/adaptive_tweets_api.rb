class AdaptiveTweetsApi
  class NotOkay < StandardError; end
  attr_reader :http

  def initialize http_library=HTTParty
    @http = http_library
  end

  def fetch_more_tweets
    response = http.get(tweets_endpoint)

    if response.code != 200
      raise NotOkay.new(response)
    end

    return response
  end

  protected
  def tweets_endpoint
    APP_CONFIG['adaptive_tweets_endpoint']
  end
end