# frozen_string_literal: true
Given(/^there is a business$/) do
  @business = FactoryBot.create(:business, domain: 'http://example.com')
end
