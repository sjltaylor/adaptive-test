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

    tweets.each do |tweet_container|
      tweet_container.should have_content('seen: 1 time')
    end

    # get the same two tweets again
    fetch_more_tweets

    tweets.each do |tweet_container|
      tweet_container.should have_content('seen: 2 times')
    end

    # one of the tweets should be highlighted
    highlighted_message = page.find(:css, '.tweet-container .about-coke').text
    highlighted_message.should == two_tweet_attrs.first["message"]

    # the tweets should be in order of sentiment
    tweets.first.should have_content("sentiment: 0.3")
    tweets.last.should have_content("sentiment: -0.5")
  end

  scenario 'filtering tweets by twitter handle' do
    two_tweet_attrs = api_mock.fetch_more_tweets.return_two_tweets

    visit_landing_page

    fetch_more_tweets

    tweets.count.should == 2

    user_handle = two_tweet_attrs.first["user_handle"]
    click_on user_handle

    tweets.count.should_not be_zero
    tweets.each do |tweet|
      tweet.should have_content("handle: #{user_handle}")
    end

    # go back to the landing page by clicking the home link
    navigate_home

    tweets.count.should == 2
  end

  scenario 'the api returns an error when fetching tweets' do
    api_mock.fetch_more_tweets.raise_not_okay

    visit_landing_page

    fetch_more_tweets

    page.should have_content('The was a problem fetching more tweets')
  end
end