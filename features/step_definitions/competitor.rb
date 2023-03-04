# frozen_string_literal: true

When(/^I click Search by Name form$/) do
  find('.col-sm-4.col-lg-3>.form-control').click
end

Then(/^I type "([^"]*)" in the search field$/) do |text|
  fill_in('searchByName', with: text)
end

Then(/^I should be able to see PDF template$/) do
  expect(page).to have_css('.dropdown-menu>.p-sm>a', text: 'PDF')
end

When(/^I select the pagination dropdown$/) do
  find('md-select-value', text: '10').click
end

When(/^I should select "([^"]*)" as limit$/) do |number|
  find('md-option', text: number, match: :first).click
end

Then(/^I should see "([^"]*)" table rows$/) do |number|
  expect(page).to have_css('tr a', text: 'View', count: number.to_i)
end

Then(/^I should see a delete confirmation window$/) do
  expect(page).to have_css('.md-dialog-container>md-dialog>.modal-header>h2', text: 'Confirm Delete Competition')
end

When(/^I add these competitors:$/) do |field_table|
  field_table.rows.each do |row|
    competitor = row.first
    find('a', text: 'Add Competitors').click
    fill_in('Enter your competitor\'s domain name', with: competitor)
    click_button('Add')
    sleep 3
  end
end

Then(/^I should see the delete message for "([^"]*)"$/) do |text|
  expect(page).to have_content "Competition \"#{text}\" deleted"
end

Then(/^I go to the Dashboard page$/) do
  visit "/b/dashboard"
  sleep 5
end
