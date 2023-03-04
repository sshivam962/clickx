# frozen_string_literal: true

Then(/^I should see the table with URL and Count$/) do
  expect(page).to have_css('tbody>tr>td>a')
  expect(page).to have_css('tbody>tr>.text-center')
end
