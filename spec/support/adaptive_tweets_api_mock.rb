module AdaptiveTweetsApiMock
  module_function

  def fetch_more_tweets
    FetchMoreTweets
  end

  module FetchMoreTweets
    module_function

    def return_two_tweets
      AdaptiveTweetsApi.any_instance.stub(:fetch_more_tweets).and_return(two_tweets)
    end

    def raise_not_okay
      AdaptiveTweetsApi.any_instance.stub(:fetch_more_tweets).and_raise(AdaptiveTweetsApi::NotOkay)
    end

    protected
    module_function

    def two_tweets
      [
        {
          "created_at" => "2012-09-27T16:11:15Z",
          "followers" => 24,
          "id" => 3,
          "message" => "Coke is it!",
          "sentiment" => 1,
          "updated_at" => "2012-09-27T16:11:15Z",
          "user_handle" => "@coke_snortr"
        },
        {
          "created_at" => "2012-09-27T16:15:06Z",
          "followers" => 5,
          "id" => 8,
          "message" => "Tweet me your fav drinks #drinks",
          "sentiment" => 0,
          "updated_at" => "2012-09-27T16:15:06Z",
          "user_handle" => "@drinkies"
        }
      ]
    end
  end
end