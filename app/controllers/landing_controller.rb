class LandingController < ApplicationController
  def index
    tweets = if params[:handle]
      Tweet.from_user(params[:handle])
    else
      Tweet.all
    end

    render locals: { tweets: tweets }
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
