When(/^I go to the facebook ads page$/) do
  visit "/#/#{@business.id}/facebook_ads"
end

When(/^I add facebook integration$/) do
  FbAdAccount.create(account_id: 'act_116945468766564', business_id: @business.id)
end