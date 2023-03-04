# frozen_string_literal: true

Then(/^I'm in Backlinks page$/) do
  visit "/#/summary"
end

When(/^I should be able to see the "([^"]*)" heading$/) do |text|
  expect(page).to have_css('div>h4', text: text)
end

When(/^I should be able to see the "([^"]*)" tab$/) do |text|
  expect(page).to have_css('a', text: text)
end
