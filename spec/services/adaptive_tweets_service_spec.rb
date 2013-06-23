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
  let(:expected_tweet1_model_attributes) do
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
  let(:expected_tweet2_model_attributes) do
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
    it 'calls the adaptive tweets test api for new tweets' do
      mock_api.should_receive(:fetch_more_tweets)
      service.fetch_more_tweets
    end

    it 'stores tweets but does not create tweets with duplicate remote ids' do
      [expected_tweet1_model_attributes, expected_tweet2_model_attributes].each do |attrs|
        Tweet.should_receive(:where).with(remote_id: attrs["remote_id"]).and_return do
          stub(:where_arel).tap do |where_arel|
            where_arel.should_receive(:first_or_create!).with(attrs)
          end
        end
      end
      service.fetch_more_tweets
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