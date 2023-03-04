# frozen_string_literal: true

Given(/^there is a business user$/) do
  business = FactoryBot.create(:business)
  @business_user = FactoryBot.create(:company_admin,
                                     username: 'test',
                                     password: 'password123',
                                     ownable: business)
end

Given(/^I signin as a business user$/) do
  visit new_user_session_path
  fill_in 'user[login]', with: 'test'
  fill_in 'user[password]', with: 'password123'
  click_button 'Sign in to My Account'
end

When(/^I visit locations page$/) do
  visit '/#/locations'
  page.has_title?('Add New Location | Clickx')
end

When(/^press new location button$/) do
  click_on('Add New Location')
end

Then(/^I must be in new location page$/) do
  page.has_title?('Add New Location | Clickx')
end

When(/^I fill the form$/) do
  fill_in :name, with: 'Clickx Inc'
  fill_in :address, with: 'Chicago'
  fill_in :city, with: 'Florida'
  fill_in :state, with: 'IL'
  fill_in :country, with: 'US'
  fill_in :zip, with: '333333'
  fill_in :phone_no, with: '1234567890'
  fill_in :website, with: 'http://clickx.io'
end

When(/^press save button$/) do
  click_button('save_basic')
end

Then(/^I should be on locations page$/) do
  page.has_title?('Locations')
end

Then(/^a new location must be added$/) do
  sleep 10
  expect(Location.count).to be_eql(1)
end
