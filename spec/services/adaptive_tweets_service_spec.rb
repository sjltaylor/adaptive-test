require 'spec_helper'

describe AdaptiveTweetsService do
  let(:service)     { AdaptiveTweetsService }
  let(:mock_api)    { mock(:mock_api) }
  let(:tweet1) do
    {
      "created_at"=>"2012-09-27T16:09:49Z",
      "followers"=>2,
      "id"=>1,
      "message"=>"I really like diet coke",
      "sentiment"=>0.7,
      "updated_at"=>"2012-09-27T16:10:42Z",
      "user_handle"=>"@coke_lvr"
    }
  end
  let(:tweet2) do
    {
      "created_at"=>"2012-09-27T16:17:21Z",
      "followers"=>19,
      "id"=>12,
      "message"=>"Pepsi is the new coke",
      "sentiment"=>0.0,
      "updated_at"=>"2012-09-27T16:17:21Z",
      "user_handle"=>"@pepsi"
    }
  end
  let(:fake_api_response) { [tweet1, tweet2] }
  let(:api_tweet_attributes_1) do
    {
      "remote_created_at"=>"2012-09-27T16:09:49Z",
      "followers"=>2,
      "remote_id"=>"1",
      "message"=>"I really like diet coke",
      "sentiment"=>0.7,
      "remote_updated_at"=>"2012-09-27T16:10:42Z",
      "user_handle"=>"@coke_lvr"
    }
  end
  let(:api_tweet_attributes_2) do
    {
      "remote_created_at"=>"2012-09-27T16:17:21Z",
      "followers"=>19,
      "remote_id"=>"12",
      "message"=>"Pepsi is the new coke",
      "sentiment"=>0.0,
      "remote_updated_at"=>"2012-09-27T16:17:21Z",
      "user_handle"=>"@pepsi"
    }
  end
  before(:each) do
    service.stub(:api).and_return(mock_api)
    mock_api.stub(:fetch_more_tweets).and_return(fake_api_response)
  end

  describe '#fetch_more_tweets' do
    let(:tweet_model_instance) do
      stub(:tweet_model_instance).tap do |t|
        t.stub(:times_seen).and_return(1)
        t.stub(:times_seen=)
        t.stub(:save!)
      end
    end

    it 'calls the adaptive tweets test api for new tweets' do
      mock_api.should_receive(:fetch_more_tweets)
      service.fetch_more_tweets
    end

    describe 'when a tweet is a repeat encounter' do
      it 'does not create a new tweet' do
        [api_tweet_attributes_1, api_tweet_attributes_2].each do |attrs|
          Tweet.stub(:find_by_remote_id).with(attrs["remote_id"]).and_return(tweet_model_instance)
          Tweet.should_not_receive(:create)
        end
        service.fetch_more_tweets
      end
    end

    describe 'when a tweet is a new encounter' do
      it 'creates a new tweet' do
        Tweet.stub(:find_by_remote_id).and_return(nil)
        [api_tweet_attributes_1, api_tweet_attributes_2].each do |attrs|
          Tweet.should_receive(:new).with(attrs).and_return(tweet_model_instance)
          tweet_model_instance.should_receive(:save!)
        end
        service.fetch_more_tweets
      end
    end

    describe 'incrementing times seen' do
      let(:tweet_from_api) { api_tweet_attributes_1 }

      before(:each) do
        mock_api.stub(:fetch_more_tweets).and_return([tweet_from_api])
      end

      it 'is 1 the first time the tweet is seen' do
        Tweet.should_receive(:find_by_remote_id).and_return(tweet_model_instance)
        tweet_model_instance.stub(:times_seen).and_return(0)
        tweet_model_instance.should_receive(:times_seen=).with(1)
        tweet_model_instance.should_receive(:save!)
        service.fetch_more_tweets
      end
      it 'is incremented each time the tweet is seen' do
        Tweet.stub(:find_by_remote_id).and_return(nil)
        Tweet.should_receive(:new).and_return(tweet_model_instance)
        tweet_model_instance.stub(:times_seen).and_return(5)
        tweet_model_instance.should_receive(:times_seen=).with(6)
        tweet_model_instance.should_receive(:save!)
        service.fetch_more_tweets
      end
    end

    describe 'when the api raises a AdaptiveTweetsApi::NotOkay' do
      before(:each) do
        mock_api.stub(:fetch_more_tweets).and_raise(AdaptiveTweetsApi::NotOkay)
      end
      it 'raises an ApiError' do
        expect { service.fetch_more_tweets }.to raise_error(AdaptiveTweetsService::ApiError)
      end
    end
  end
end