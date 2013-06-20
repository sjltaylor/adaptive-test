class LandingController < ApplicationController
  def index
    render locals: { tweets: Tweet.all }
  end
  def fetch_more_tweets
    adaptive_tweets.fetch_more_tweets
    redirect_to :root
  end

  protected
  def adaptive_tweets
    AdaptiveTweetsService
  end
end
