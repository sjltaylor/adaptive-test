require 'spec_helper'

describe LandingController do
  context 'routing' do
    it { should route(:get,  '/')                 .to :action => :index }
    it { should route(:post, '/fetch_more_tweets').to :action => :fetch_more_tweets }
  end

  describe '#index' do
    let(:all_tweets) { stub(:all_tweets) }
    before(:each) { controller.stub(:render) }

    it 'renders with all tweets in descending order of sentiment' do
      Tweet.should_receive(:order).with('sentiment DESC').and_return(all_tweets)
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

    describe 'when there is an error calling the api' do
      let(:error) do
        StandardError.new.tap do |e|
          e.extend AdaptiveTweetsService::ApiError
        end
      end
      it 'sets a flash message' do
        service.stub(:fetch_more_tweets).and_raise(error)
        dispatch
        flash[:error].should == 'The was a problem fetching more tweets'
      end
    end
  end
end