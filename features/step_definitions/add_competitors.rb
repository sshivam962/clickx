# frozen_string_literal: true

When(/^I go to the competition page$/) do
  visit '/#/competition'
end

Then(/^I should see the "([^"]*)" button$/) do |text|
  expect(page).to have_css('.btn', text: text)
end

When(/^I click on the button "([^"]*)" in the page$/) do |text|
  first('a', text: text).click
end

Then(/^I should see the add competitors dialog box$/) do
  expect(page).to have_css('#add_comp_form')
end

Then(/^I fill the competitors domain as "([^"]*)"$/) do |text|
  fill_in('Enter your competitor\'s domain name', with: text)
end

Then(/^I click on the Add submit button$/) do
  find('.layout-row>.btn.btn-raised.mt-md.mb-md.btn-primary').click
  sleep 5
end

Then(/^I should see the link "([^"]*)" on the page$/) do |link|
  expect(page).to have_css('a>h4', text: link, match: :first)
end
