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
      e.extend ApiError
      raise e
    end.each do |tweet|
      remote_id = tweet["id"].to_s

      Tweet.where(remote_id: remote_id).first_or_create!(
        tweet.slice(*TWEET_SLICE_ATTRS).merge(
          'remote_id'         => tweet['id'].to_s,
          'remote_created_at' => tweet['created_at'],
          'remote_updated_at' => tweet['updated_at']
        )
      )
    end
  end

  protected
  def api
    @adaptive_tweets_api ||= AdaptiveTweetsApi.new
  end
end