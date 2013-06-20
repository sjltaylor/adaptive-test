require 'spec_helper'

describe LandingController do
  context 'routing' do
    it { should route(:get,  '/')                 .to :action => :index }
    it { should route(:post, '/fetch_more_tweets').to :action => :fetch_more_tweets }
  end

  describe '#index' do
    let(:all_tweets) { stub(:all_tweets) }
    before(:each) { Tweet.stub(:all).and_return(all_tweets) }
    before(:each) { controller.stub(:render) }

    it 'renders with all tweets' do
      controller.should_receive(:render).with(locals: { tweets: all_tweets })
      get :index
    end
  end

  describe '#fetch_more_tweets' do
    let(:service) { mock(:adaptive_tweets_service, fetch_more_tweets: nil) }
    before(:each) { controller.stub(:adaptive_tweets).and_return(service) }

    def dispatch
      post :fetch_more_tweets
    end

    it 'redirects to the landing page' do
      dispatch
      response.should redirect_to(root_path)
    end

    it 'calls #fetch_more_tweets on the adaptive tweets service' do
      service.should_receive(:fetch_more_tweets)
      dispatch
    end
  end
end