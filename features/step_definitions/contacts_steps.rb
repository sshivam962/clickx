require 'tempfile'

When(/^I go to the contacts page$/) do
  visit "/#/leads"
end

Then(/^I should see the add contacts dialogue box$/) do
  expect(find(:xpath, "//md-dialog[@aria-label='Add Contacts']"))
end

Then(/^I should see "([0-9]*)" contacts?$/) do |number|
  sleep 0.3
  expect(page).to have_selector('table tbody>tr', count: number)
end

When(/^I fill in the fields with:$/) do |table|
  data = table.rows_hash
  find(:xpath, "//input[@ng-model='lead.fname']").set(data["First Name"])
  find(:xpath, "//input[@ng-model='lead.lname']").set(data["Last Name"])
  find(:xpath, "//input[@ng-model='lead.email']").set(data["Email"])
  find(:xpath, "//input[@ng-model='lead.phone']").set(data["Phone"])
  find(:xpath, "//textarea[@ng-model='lead.address']").set(data["Address"])
  find(:xpath, "//input[@ng-model='lead.job_title']").set(data["Job Title"])
  find(:xpath, "//input[@ng-model='lead.organization']").set(data["Organization"])
  find(:xpath, "//md-radio-button[@value='#{data['Gender']}']").click
  find(:xpath, "//md-select[@ng-model='lead.nationality']").click #open country drop down
  find(:xpath, "//md-option[@value='#{data['Country']}']").click #select country
end

When(/^I upload a csv with this data:$/) do |field_table|
  ruport = Ruport::Data::Table.new(column_names: field_table.hashes.first.keys)
  field_table.hashes.each { |hash| ruport << hash }
  @current_import_file = Tempfile.new(['import', '.csv'])
  @current_import_file << ruport.to_csv
  @current_import_file.close
  find("input[type='file']", visible: false).set(@current_import_file.path())
end
