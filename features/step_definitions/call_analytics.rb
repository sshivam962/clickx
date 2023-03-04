# frozen_string_literal: true

When(/^I visit Call Analytics page$/) do
  @business.update(call_analytics_id: 'CtjSZVGKa-dELQBN')
  visit "/#/calls"
end

Then(/^it should have three graphs and one table$/) do
  within('div#calls_by_status_chart') do
    find('div.highcharts-container')
  end
  within('div#unique_calls_chart') do
    find('div.highcharts-container')
  end
  within('div#leads_per_day_chart') do
    find('div.highcharts-container')
  end
  page.has_table?('table', count: 1)
end

When(/^I select the pagination dropdown "([^"]*)"$/) do |text|
  find('span>div', text: '10').click
  sleep 2
  find('#select_option_3', text: text).click
end

When(/^I should see "([^"]*)" contents on the table$/) do |text|
  expect(page).to have_css('.fa.fa-plus', count: text)
end

When(/^I click on the plus icon$/) do
  find('button>.fa.fa-plus', match: :first).click
end

Then(/^I should be able to see the call start date and time$/) do
  find('button>.fa.fa-plus', match: :first).click
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.success>td')
end

Then(/^I should be able to see the inbound  number$/) do
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.success>td')
end

Then(/^I should be able to see the caller name$/) do
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.success>td>p')
end

Then(/^I should be able to see the call end date and time$/) do
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.warning>td>p')
end

Then(/^I should be able to see the answered by number$/) do
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.warning>td>p')
end

Then(/^I should be able to see the caller number$/) do
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>.warning>td>p')
end

Then(/^I should be able to see the link "([^"]*)"$/) do |text|
  expect(page).to have_css('.table.call_details_table.mb-n>tbody>tr>td>a', text: text)
end

Then(/^I should be able to see the audio file downloaded$/) do
  expect(File.exist?('tmp/call_recording.mp3')).to eq true
end
