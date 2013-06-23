require 'spec_helper'

feature 'landing page' do
  include Habits::Navigation
  include Habits::Actions
  include UI::LandingPage
  let(:api_mock){ AdaptiveTweetsApiMock }
  let(:expected_heading) { 'All About "Coke"' }

  scenario 'visiting the landing page' do
    visit_landing_page
    expect(page).to have_title(expected_heading)
    page.find(:css, 'h1').text.should == expected_heading
  end

  scenario 'fetching and listing tweets' do
    two_tweet_attrs = api_mock.fetch_more_tweets.return_two_tweets

    visit_landing_page

    expect{ fetch_more_tweets }.to change{ tweets.count } .from(0).to(2)

    two_tweet_attrs.each do |tweet_attrs|
      page.should have_content("handle: #{tweet_attrs['user_handle']}")
      page.should have_content("message: #{tweet_attrs['message']}")
      page.should have_content("sentiment: #{tweet_attrs['sentiment']}")
    end
  end

  scenario 'the api returns an error when fetching tweets' do
    api_mock.fetch_more_tweets.raise_not_okay

    visit_landing_page

    fetch_more_tweets

    page.should have_content('The was a problem fetching more tweets')
  end
end