module AdaptiveTweetsService
  TWEET_SLICE_ATTRS = [
    'message',
    'followers',
    'user_handle',
    'sentiment'
  ].freeze

  extend self

  def fetch_more_tweets
    tweets = api.fetch_more_tweets
    tweets.each do |tweet|
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