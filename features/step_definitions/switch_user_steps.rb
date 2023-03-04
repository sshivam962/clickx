
And(/^there is an Agency admin$/) do
  @agency_admin = FactoryBot.build(:agency_admin)
  @agency_admin.assign_attributes({
    ownable: @agency
  })
  @agency_admin.save
end

And(/^there is a Business User$/) do
  @business_user = FactoryBot.create(:user)
  @business.users << @business_user
  @business_user.update_attributes({
    ownable: @busines
  })
end

And(/^there is a Company Admin$/) do
  @company_admin = FactoryBot.create(:company_admin)
  @business.users << @company_admin
  @company_admin.update_attributes({
    ownable: @business
  })
end
Given(/^There is one more business$/) do
  @another_business = FactoryBot.create(:business, agency_id: @agency.id)
end

Given(/^business belongs to agency$/) do
  @business.update_attribute :agency_id, @agency.id
end

Then(/^agency should be listed$/) do
  expect(page).to have_content(@agency.name)
end

Then(/^business should be listed$/) do
  expect(page).to have_content(@business.name)
end


Then(/^select Agency admin for Agency$/) do
  find('.select-box',match: :first).click
  find('.ui-select-choices-row',text: @agency_admin.login, match: :first).click
end

Then(/^I click on the link View Dashboard$/) do
  find('a', text: "View Dashboard", match: :first).click
end

Then(/^I should see Agency admin as current user$/) do
  expect(page).to have_content(@agency_admin.login)
end

When(/^I click on the link Switch To Admin User$/) do
  #visit '/switch_to_admin_user'
  page.all('.myaccounticon')[1].click
  find('a', text: "Switch To Admin User").first(:xpath, './/..').click
end

Then(/^I should see the Admin email on the page$/) do
  expect(page).to have_content @user.email
end

Then(/^I clink the switch user link$/) do
  #find('a[ng-click="switch_user(biz.system_user)"]', match: :first).click
  visit "/switch_to_business_user?user_id=#{@business_user.id}&feature=dashboard&business_id=#{@business.id}"
end

When(/^I visit Agency Dashboard$/) do
  visit "/#/agencies/#{@agency.id}/dashboard"
end

Then(/^I select Business User and select go to Dashboard$/) do
  page.all('md-select')[3].click
  page.all('.ng-binding', text: 'System User')[1].first(:xpath,".//..").first(:xpath,".//..").click

  page.all('md-select')[2].click
  page.find('.ng-binding', text: 'Dashboard').first(:xpath,".//..").first(:xpath,".//..").click
end 

Then(/^I click profile info$/) do
  page.find('.myaccounticon', match: :first).click
end

Then(/^I select one of the business users$/) do
  find('a', text: @company_admin.first_name).click
end

Then(/^I should be prompted to Select a Campaign$/) do
  expect(page).to have_content("Select a Campaign")
end

Then(/^I click profile settings$/) do
  page.all('.myaccounticon')[1].click
end

Then(/^I should see Agency admin first name on profile info$/) do
  expect(page).to have_content(@user.login)
end

When(/^I click on the link Agencies$/) do
  page.find('i.agency-icon').hover
  page.find('i.agency-icon').first(:xpath, './/..').click
end
