module Habits
  module Navigation
    def visit_landing_page
      visit '/'
    end
    def navigate_home
      click_on 'Home'
    end
  end
end