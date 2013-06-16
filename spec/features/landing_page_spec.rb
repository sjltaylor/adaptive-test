require 'spec_helper'

feature 'landing page' do
  include Habits::Navigation
  let(:expected_heading) { 'All About "Coke"' }

  scenario 'visiting the landing page' do
    visit_landing_page
    expect(page).to have_title(expected_heading)
    page.find(:css, 'h1').text.should == expected_heading
  end
end