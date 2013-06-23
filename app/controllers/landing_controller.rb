class LandingController < ApplicationController
  def index
    render locals: { tweets: Tweet.order('sentiment DESC') }
  end
  def fetch_more_tweets
    begin
      adaptive_tweets.fetch_more_tweets
    rescue AdaptiveTweetsService::ApiError
      # rescue only api errors, other exceptions should bubble up
      flash[:error] = 'The was a problem fetching more tweets'
    end
    redirect_to :root
  end

  protected
  def adaptive_tweets
    AdaptiveTweetsService
  end
end
