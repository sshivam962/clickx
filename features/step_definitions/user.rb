# frozen_string_literal: true
Given(/^I am not authenticated$/) do
  visit('/users/sign_out')
end

Given(/^I'm a "(Company User|Company Admin|Agency Admin|Admin)"$/) do |user_type|
  role = user_type.downcase.tr(' ', '_')
  if role == 'company_user' || role == 'company_admin' && @business.present?
    ownable_id = @business.id
    ownable_type = 'Business'
  elsif role == 'agency_admin' && @agency.present?
    ownable_id = @agency.id
    ownable_type = 'Agency'
  else
    ownable_id = nil
    ownable_type = nil
  end
  email = 'testing@man.net'
  password = 'secretpass'
  first_name = 'joe'
  last_name = 'adimaly'
  invitation_accepted_at = Time.current
  @user = FactoryBot.create(:user, email: email, password: password,
                                   first_name: first_name, last_name: last_name,
                                   invitation_accepted_at: invitation_accepted_at, role: role,
                                   ownable_id: ownable_id, ownable_type: ownable_type)

  login_as @user
end

Given(/^I set the required cookies$/) do
  page.driver.browser.manage.add_cookie name: 'current_business_id', value: @business.id.to_s
  page.driver.browser.manage.add_cookie name: 'current_agency_id', value: @business.agency.id.to_s
  page.driver.browser.navigate.refresh
end
