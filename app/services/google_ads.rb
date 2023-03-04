# frozen_string_literal: true

require 'google/ads/google_ads'

class GoogleAds
  attr_reader :customer_id, :token

  def initialize(token:, customer_id: nil)
    @token = token
    @customer_id = customer_id
  end

  def client
    @_client ||= Google::Ads::GoogleAds::GoogleAdsClient.new do |c|
      c.treat_deprecation_warnings_as_errors = Rails.env.development?
      c.warn_on_all_deprecations = Rails.env.development?

      c.developer_token = ENV['GOOGLE_ADS_DEVELOPER_TOKEN']
      c.client_id = ENV['GOOGLE_ADS_CLIENT']
      c.client_secret = ENV['GOOGLE_ADS_SECRET']
      c.refresh_token = token.refresh_token
      if customer_id.present?
        c.login_customer_id = customer_id
      end

      # Valid values are 'FATAL', 'ERROR', 'WARN', 'INFO', and 'DEBUG'
      c.log_level = 'WARN'
      c.log_target = STDOUT

      # Instead of specifying logging through level and target, you can also pass a
      # logger directly (e.g. passing Rails.logger in a config/initializer). The
      # passed logger will override log_level and log_target.
      # c.logger = Logger.new(STDOUT)
    end
  end
end
