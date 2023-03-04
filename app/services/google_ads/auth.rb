# frozen_string_literal: true

require 'google/ads/google_ads'

class GoogleAds::Auth
  SCOPE = 'https://www.googleapis.com/auth/adwords'
  CALLBACK_URL = ROOT_URL + '/b/google_ads/oauth2callback'

  def self.authorizer
    client_id = Google::Auth::ClientId.new(
      ENV['GOOGLE_ADS_CLIENT'], ENV['GOOGLE_ADS_SECRET']
    )

    @authorizer ||= Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, nil, CALLBACK_URL
    )
  end
end
