
# frozen_string_literal: true

And(/^I set page size to include all elements$/) do
  page.driver.browser.manage.window.resize_to(1280, 2000)
end

When(/^I click on the link "([^"]*)"$/) do |link|
  find('a', text: link, match: :first).click
end

When(/^I click on the button "([^"]*)"$/) do |link|
  find('button', text: link, match: :first).click
end

Then(/^I should see the text "([^"]*)" on the page$/) do |text|
  expect(page).to have_content text
end

Then(/^I should not see the text "([^"]*)" on the page$/) do |text|
  expect(page).to have_no_content(text)
end

Then(/^I should see "([^"]*)" in the title of the page$/) do |title_text|
  expect(page).to have_title title_text
end

Then(/^I should have a link with text "([^"]*)"$/) do |text|
  expect(page.find('a', text: text, match: :first))
end

When(/^I am in the "([^"]*)" page$/) do |url|
  visit "/#/#{@business.id}/#{url}"
end

When(/^I visit "([^"]*)"$/) do |url|
  visit url
end

Then(/^I should see the "([^"]*)" panel$/) do |panel|
  expect(page).to have_css('.panel>.panel-heading>h2', text: panel)
end

Then(/^I should see the active tab "([^"]*)"$/) do |_tab|
  expect(page).to have_css('li.active')
end

When(/^I should have a button with text "([^"]*)"$/) do |text|
  expect(page).to have_css('button', text: text)
end
