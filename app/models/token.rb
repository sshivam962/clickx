# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :business, optional: true
  GoogleAccessToken = 'google_access_token'
  AnalyticsAccessToken = 'analytics_access_token'
  SearchConsoleAccessToken = 'search_console_access_token'
  AdwordAccessToken = 'adword_access_token'
  HubspotAccessToken = 'hubspot_access_token'
  FbAccessToken = 'facebook_access_token'
  OneimsToken = 'oneims_token'
  GoogleAdsToken = 'google_ads_token'

  scope :of_type, ->(type) { where(code_type: type) }

  def valid_token?
    access_token.present?
  end

  def invalid_token?
    !valid_token?
  end

  def expired?
    (expires_at || Time.current - 10.minutes).past?
  end

  def refresh_token!
    available_types = %w[google_adwords google_adwords_display google_adwords_video adword_access_token adword_keyword_planner google_ads_token]
    raise 'Not implemeneted ' unless available_types.include?(code_type)
    AdwordsAuth.refresh_adword_access_token(self)
  end
end
