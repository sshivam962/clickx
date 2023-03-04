# frozen_string_literal: true

When(/^I go to the new user registration page$/) do
  visit free_path
end

Given(/^there is a mailtemplate$/) do
  @mailtemplate = FactoryBot.create(:mail_template)
end

When(/^I fill the signup form$/) do
  fill_in 'user[first_name]', with: 'Jon'
  fill_in 'user[last_name]', with: 'Doe'
  fill_in 'user[email]', with: 'jon@doe.com'
  fill_in 'user[phone]', with: '9999888877'
  fill_in 'business[name]', with: 'Clickx'
  fill_in 'business[domain]', with: 'http://sampletest.com/'
  fill_in 'business[target_city]', with: 'test city'
  find('#tnc', visible: false).set(true)
end

When(/^I click the button "([^"]*)"$/) do |button_name|
  click_button button_name
end

When(/^I submit the form$/) do
  find('input[name="commit"]').click
end

Then(/^I should See "([^"]*)"$/) do |text|
  expect(page).to have_text(text)
end
