# frozen_string_literal: true

Then(/^I click on the contact in the table$/) do
  find('a', text: 'developer@develop.com').click
end

Then(/^I should see the Edit button$/) do
  expect(page).to have_css('.pull-right>.btn', text: 'Edit')
end

Then(/^I edit all the fields with:$/) do
  fill_in 'First Name', with: 'Tester'
  fill_in 'Last Name', with: 'test'
  fill_in 'Email', with: 'tester@test.co'
  fill_in 'Phone', with: '9958468521'
  fill_in 'Address', with: 'No 1, SM street'
end

Then(/^I should see "([^"]*)" notification$/) do |message|
  expect(page).to have_css('div.toast-message', text: message)
end

Then(/^I should see the Delete button$/) do
  expect(page).to have_css('.pull-right>button', text: 'Delete')
end

Then(/^I should see the NOTES button$/) do
  expect(page).to have_css('.pull-right>button>b', text: 'NOTES')
end

Then(/^I should see the form$/) do
  expect(page).to have_css('.form-group>.form-control')
end

Then(/^I fill the form with sample note$/) do
  fill_in 'Your Note here', with: 'sample note'
end

Then(/^I should see sample note as content$/) do
  expect(page).to have_css('.activity-info.notes>.text', text: 'sample note')
end

Then(/^I should see the Contact dropdown$/) do
  expect(page).to have_css('.btn-group>.btn', text: 'Contact')
end

Then(/^I click on the Contact dropdown$/) do
  find('.btn-group>.btn', text: 'Contact', match: :first).click
end

Then(/^I should be able to select Lead template$/) do
  find('.dropdown-menu>li>a', text: 'Lead').click
end

When(/^I refresh the page$/) do
  page.driver.browser.navigate.refresh
end

Then(/^I click on the button Save to submit note$/) do
  find('.btn.btn-info.btn-raised.btn-lg', text: 'Save').click
end
