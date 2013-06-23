require 'spec_helper'

describe AdaptiveTweetsApi do
  let(:fake_url) { 'http://not-the-real-url.com' }
  let(:http_library) { mock }
  let(:api) { described_class.new(http_library) }

  describe '#fetch_more_tweets' do
    let(:response_stub) { stub(:response, code: 200) }

    before(:each) do
      http_library.stub(:get).and_return(response_stub)
    end

    it 'calls the url from configuration' do
      api.should_receive(:tweets_endpoint).and_return(fake_url)
      http_library.should_receive(:get).with(fake_url).and_return(response_stub)
      api.fetch_more_tweets
    end

    describe 'when the request is successful' do
      it 'returns the parsed JSON body of the response' do
        api.fetch_more_tweets.should == response_stub
      end
    end

    describe 'when the request is unsuccessful' do
      context 'because of a client error' do
        before(:each) do
          http_library.should_receive(:get).and_return(stub(:client_error, code: 403))
        end
        it 'raises AdaptiveTweetsApi::NotOkay' do
          expect{ api.fetch_more_tweets }.to raise_error AdaptiveTweetsApi::NotOkay
        end
      end
      context 'because of a server error' do
        before(:each) do
          http_library.should_receive(:get).and_return(stub(:client_error, code: 500))
        end
        it 'raises AdaptiveTweetsApi::NotOkay' do
          expect{ api.fetch_more_tweets }.to raise_error AdaptiveTweetsApi::NotOkay
        end
      end
    end
  end
end