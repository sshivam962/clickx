# frozen_string_literal: true

namespace :integration_details do
  desc 'Update integration details for connected accounts'
  task connected_accounts: :environment do
    integration_detail = IntegrationDetails.new
    Business.find_each do |business|
      integration_detail.update_facebook(business)
      integration_detail.update_google_ads_details(business)
    end
  end
end
