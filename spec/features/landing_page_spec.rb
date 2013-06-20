require 'spec_helper'

feature 'landing page' do
  include Habits::Navigation
  include UI::LandingPage

  let(:expected_heading) { 'All About "Coke"' }

  scenario 'visiting the landing page', vcr: { cassette_name: 'landing_page/adaptive_tweets' } do
    visit_landing_page
    expect(page).to have_title(expected_heading)
    page.find(:css, 'h1').text.should == expected_heading
  end

  scenario 'fetching and listing tweets', vcr: { cassette: 'fetch_more_tweets' } do
    visit_landing_page

    # refactor me to pass the lambda as the block
    fetch_more_tweets = ->{ click_on('Fetch more tweets') }

    expect do
      fetch_more_tweets.()
    end.to change{ tweets.count }.from(0).to(2)
  end
end