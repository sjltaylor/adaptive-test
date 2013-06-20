require 'spec_helper'

describe AdaptiveTweetsApi do
  let(:fake_url) { 'http://not-the-real-url.com' }
  let(:http_library) { mock }
  let(:api) { described_class.new(http_library) }

  describe '#fetch_more_tweets' do
    let(:response_stub) { stub(:response) }

    before(:each) do
      http_library.stub(:get).and_return(response_stub)
    end

    it 'calls the url from configuration' do
      api.should_receive(:tweets_endpoint).and_return(fake_url)
      http_library.should_receive(:get).with(fake_url).and_return(response_stub)
      api.fetch_more_tweets
    end
    it 'returns the parsed JSON body of the response' do
      api.fetch_more_tweets.should == response_stub
    end
  end
end