class LandingController < ApplicationController
  def index
    render locals: { tweets: Tweet.all }
  end
  def fetch_more_tweets
    begin
      adaptive_tweets.fetch_more_tweets
    rescue AdaptiveTweetsService::ApiError
      flash[:error] = 'The was a problem fetching more tweets'
    end
    redirect_to :root
  end

  protected
  def adaptive_tweets
    AdaptiveTweetsService
  end
end
