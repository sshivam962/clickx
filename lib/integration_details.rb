# frozen_string_literal: true

class IntegrationDetails
  def update_facebook(business)
    return unless business.fb_access_token?
    graph = Koala::Facebook::API.new(business.fb_access_token)
    response = graph.get_object('me')
    manage_integration_details(business, 'facebook_account', response['name'])
  rescue Koala::Facebook::AuthenticationError
    nil
  end

  def update_google_ads_details(business)
    return unless business.google_ads_service?

    token = business.tokens.find_by(code_type: Token::GoogleAdsToken)
    return if token.blank?

    adword_data = GoogleAds::Account.fetch(business)
    return unless adword_data

    manage_integration_details(business, 'google_ads', adword_data[:name])
  end

  def manage_integration_details(business, key, value)
    if business.integration_detail.nil?
      business.create_integration_detail(details: Hash[key, value])
    else
      existing_details = business.integration_detail['details']
      business
        .integration_detail
        .update(details: existing_details.merge(Hash[key, value]))
    end
  end
end
