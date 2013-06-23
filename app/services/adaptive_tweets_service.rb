module AdaptiveTweetsService
  module ApiError; end

  TWEET_SLICE_ATTRS = [
    'message',
    'followers',
    'user_handle',
    'sentiment'
  ].freeze

  extend self

  # will raise an ApiError if the api results in non-200 response
  def fetch_more_tweets
    begin
      api.fetch_more_tweets
    rescue AdaptiveTweetsApi::NotOkay => e
      # tag and re-raise the exception
      e.extend ApiError
      raise e
    end.each do |tweet_attrs|
      remote_id = tweet_attrs['id'].to_s

      tweet = Tweet.find_by_remote_id(remote_id)

      if tweet.nil?
        tweet = Tweet.new(
          tweet_attrs.slice(*TWEET_SLICE_ATTRS).merge(
            'remote_id'         => tweet_attrs['id'].to_s,
            'remote_created_at' => tweet_attrs['created_at'],
            'remote_updated_at' => tweet_attrs['updated_at']
          )
        )
      end

      tweet.times_seen += 1
      tweet.save!
    end
  end

  protected
  def api
    @adaptive_tweets_api ||= AdaptiveTweetsApi.new
  end
end