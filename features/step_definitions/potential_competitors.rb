# frozen_string_literal: true

Then(/^I should see the active tab "([^"]*)" in the page$/) do |tab|
  expect(page).to have_css('.md-tab.ng-scope.ng-isolate-scope.md-ink-ripple.md-active>span', text: tab)
end

When(/^I click on the "([^"]*)" tab$/) do |tab|
  page.find('md-tab-item>.ng-scope', text: tab).click
end

Then(/^I should see the competitor on the From Organic Traffic tab$/) do
  expect(page).to have_css('a>.list-group-item-heading.ng-binding', text: 'google.com')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '0.09')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '56')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '234335041')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '605056833')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '1267689498')
end

Then(/^I should see the competitor on the From Paid Traffic tab$/) do
  expect(page).to have_css('a>.list-group-item-heading.ng-binding', text: 'google.com')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '1.59')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '1693')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '460438')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '4828622')
  expect(page).to have_css('tbody>tr>.text-center.ng-binding', text: '3960830')
end
