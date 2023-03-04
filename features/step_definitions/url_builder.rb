# frozen_string_literal: true

When(/^I visit URL Builder page$/) do
  visit "/#/campaigns"
end

When(/^I should be able to see the Add URL popup window$/) do
  expect(page).to have_css('md-dialog')
end

When(/^I should be able to fill the Website URL as "([^"]*)"$/) do |text|
  page.all('input')[0].set(text)
end

When(/^I should be able to fill the Campaign Source as "([^"]*)"$/) do |text|
  page.all('input')[1].set(text)
end

When(/^I should be able to fill the Campaign Medium as "([^"]*)"$/) do |text|
  page.all('input')[2].set(text)
end

When(/^I should be able to fill the Campaign Name as "([^"]*)"$/) do |text|
  page.all('input')[3].set(text)
end

When(/^I should be able to fill the Campaign Term as "([^"]*)"$/) do |text|
  page.all('input')[4].set(text)
end

When(/^I should be able to fill the Campaign Content as "([^"]*)"$/) do |text|
  page.all('input')[5].set(text)
end

When(/^I click on the Save button$/) do
  page.find('md-dialog-actions>.btn.btn-raised.btn-primary').click
  sleep 1
end

When(/^I should be able to see the Campaign Name "([^"]*)"$/) do |text|
  expect(page).to have_css('tbody>tr>td', text: text)
end

When(/^I should be able to see the Complete URL "([^"]*)"$/) do |text|
  expect(page).to have_css('td>div>a', text: text)
end

When(/^I click on the icon of Go to the URL$/) do
  page.find('td>div>a>.fa.fa-link').click
end

When(/^I click on the icon Delete the Campaign$/) do
  page.find('td>div>a>.icfont.material-icons.clx-text.clx-white-text').click
  page.driver.browser.switch_to.alert.accept
end

Then(/^I should be able to see the "([^"]*)" template$/) do |text|
  expect(page).to have_css('div>ul>li>a', text: text)
end

When(/^I click on the Submit button$/) do
  page.find('md-dialog-actions>.btn.btn-raised.btn-primary').click
end

When(/^I click on the icon Edit the campaign$/) do
  sleep 1
  page.all('td>div>a>.icfont.material-icons')[1].click
end

When(/^I click on the complete URL$/) do
  expect(page).to have_css('td>div>a')
end

When(/^I should be able to close the window of link$/) do
  page.driver.browser.switch_to.window page.driver.browser.window_handles.first
end

When(/^I click on the link "([^"]*)" to add url$/) do |link|
  find('a', text: link, match: :first).click
end
