# frozen_string_literal: true

When(/^I go to the keywords page$/) do
  visit "/#/rankings"
end

Then(/^I should have a filter with button named Keywords$/) do
  expect(find('#keyword', visible: false))
end

Then(/^I should have a filter with button named Google$/) do
  expect(find('#google', visible: false))
end

Then(/^I should have a filter with button named Search Volume$/) do
  expect(find('#search-volume', visible: false))
end

Then(/^I should have a filter with button named CPC$/) do
  expect(find('#cpc', visible: false))
end

Then(/^I should have a filter with button named Keyword Difficuty$/) do
  expect(find('#keyword-diff', visible: false))
end

Then(/^I should see "([^"]*)" template$/) do |text|
  expect(page).to have_css('.dropdown-menu>.p-sm>a', text: text)
end

Then(/^I click on the "([^"]*)" template$/) do |text|
  find('.dropdown-menu>.p-sm>a', text: text).click
end

Then(/^I should be able to Select keyword$/) do
  find('#keyword-').click
end

Then(/^I should be able to Select All keyword$/) do
  find('#select_keywords').click
end

Then(/^I should see the add keyword dialog box$/) do
  expect(page).to have_css('md-dialog')
end

Then(/^I should see the add tags dialog box$/) do
  expect(page).to have_css('md-dialog')
end

Then(/^I should be able to type "([^"]*)" keywords$/) do |text|
  find('md-input-container>input').click
  fill_in('Specify a Keyword', with: text)
end

Then(/^I should be able to type keyword "([^"]*)" in the box$/) do |text|
  find('#keyword-form-text').click
  fill_in('Please specify 1 keyword per line..', with: text)
end

Then(/^I should be able to type tags$/) do
  find('textarea').click
  fill_in('Enter tag', with: 'seo')
end

Then(/^I should see added keyword "([^"]*)" in the page$/) do |text|
  expect(page).to have_css('.editable-click.ng-binding', text: text)
end

Then(/^I click on the button "Add" in the dialog box$/) do
  find('.btn.btn-raised.mt-md.mb-md.btn-primary').click
end

Then(/^I click on the "([^"]*)" filter$/) do |text|
  find('.switch', text: text).click
end

Then(/^I should be able to filter content "([^"]*)"$/) do |text|
  expect(page).to have_no_css('th>b', text: text)
end

Then(/^I should be able to see added tags$/) do
  expect(page).to have_css('div>a>.name.ng-binding', text: 'seo')
end

Then(/^I should not be able to see added tags$/) do
  expect(page).to have_no_css('div>a>.name.ng-binding', text: 'seo')
end

Then(/^I click on the added tags$/) do
  find('div>a>.name.ng-binding').click
end

Then(/^I should be able to see the tag number as 0$/) do
  expect(page).to have_css('small>.badge.ng-binding', text: '0')
end

Then(/^I click on the keywords search field$/) do
  find('.pl-n.input-group>input').click
end

Then(/^I enter the keyword "([^"]*)" to search$/) do |text|
  fill_in('Keyword', with: text)
end

Then(/^I click on the dropdown "([^"]*)"$/) do |text|
  find('md-select-value>span>div', text: text).click
end

Then(/^I should see "([^"]*)" template in dropdown$/) do |text|
  expect(page).to have_css('md-option>div', text: text)
end

Then(/^I click on the "([^"]*)" template in dropdown$/) do |text|
  find('md-option>div', text: text).click
end

Then(/^I should be able to select "([^"]*)" as time span$/) do |text|
  expect(page).to have_css('md-select-value>span>div', text: text)
end

Then(/^I should be able to see the day and date$/) do
  # delete_date = Time.zone.now.strftime("%A %-dth %B %Y")
  expect(page).to have_css('div>h4')
end

Then(/^I should be able to see the deleted keyword$/) do
  expect(page).to have_css('div>code', text: 'competitors')
end
