# frozen_string_literal: true
# Check the Title of page
Then(/^I should see the title "([^"]*)"$/) do |title|
  page.has_title?(title)
end

# Expect the page to contain a date range picker with default range of last 30 days
Then(/^a date range picker with date range of last 30 days$/) do
  start_date = 30.days.ago.strftime("%b %d, %Y")
  end_date = Time.now.strftime("%b %d, %Y")
  time_string = "#{start_date} - #{end_date}"
  page.has_button?(time_string, count: 1)
end

# Expect the page to contain a back button
Then(/^also a back button$/) do
  page.has_link?('Back', count: 1)
end

# Expect the page to contain Bread Crumbs
Then(/^I should see Bread Crumbs "([^"]*)"$/) do |links|
  within("ol.breadcrumb.clx-breadcrumb") do
    links.split('/').each do |link|
      page.has_link?(link, count: 1)
    end
  end
end