# frozen_string_literal: true

# These rake tasks are to pre cache daily anayltics data from various third party providers
# These tasks should run morning everyday
require "#{Rails.root}/lib/google_search_console"
require "#{Rails.root}/lib/majestic"
namespace :cache_api_response do
  include GoogleSearchConsole
  include Majestic

  Rails.logger = Logger.new(STDOUT)

  desc "Caching adword campaigns for #{Date.current}"
  task adword_campaigns_data: :environment do
    Business.search_adwords_enabled.each do |business|
      Rails.logger.info "Caching adwords data for #{business.name}"
      begin
        get_cached_adword_campaigns(business.adword_client_id) if business.adword_client_id.present?
      rescue StandardError => e
        Rails.logger.error "Error in #{business.name} :  #{e.message}"
      end
    end
  end

  desc "Caching call anayltics for #{Date.current}"
  task call_analytics_data: :environment do
    start_time = Date.current.last_month.beginning_of_month
    end_time = Date.current.last_month.end_of_month
    params = { extended: true, start: start_time.to_s, end: end_time.to_s }
    Business.where(call_analytics_service: true).each do |business|
      call_marchex_api([business.call_analytics_id, params], 'call.search')
    end
  end

  desc "Caching google analytics for #{Date.current}"
  task google_analytics_data: :environment do
    @start_date = (Date.current - 9.days).strftime('%Y-%m-%d')
    @end_date = Date.current.strftime('%Y-%m-%d')
    Business.analytics_connected.each do |business|
      next unless business.google_analytics_service?
      auth_google_client = get_google_client(business)
      begin
        get_google_api_data(auth_google_client, business.google_analytics_id, @start_date, @end_date)
      rescue StandardError => e
        Rails.logger.error "Error in #{business.name} :  #{e.message}"
      end
    end
  end

  desc "Caching google search console for #{Date.current}"
  task google_search_console_data: :environment do
    @start_date = (Date.current - 9.days).strftime('%Y-%m-%d')
    @end_date = Date.current.strftime('%Y-%m-%d')
    Business.search_console_connected.each do |business|
      auth_google_client = get_google_client(business)
      begin
        get_search_console_overview(auth_google_client, @start_date, @end_date, business.site_url)
      rescue StandardError => e
        Rails.logger.error "Error in #{business.name} :  #{e.message}"
      end
    end
  end

  desc "Caching backlinks summary for #{Date.current}"
  task backlinks_summary_data: :environment do
    Business.where(backlink_service: true).each do |business|
      updated_at = business.backlink_datum.summary_updated_at if business.backlink_datum
      next if updated_at.blank?
      begin
        response = get_backlink_summary(business.domain)
      rescue StandardError => e
        Rails.logger.error "Error in #{business.name} :  #{e.message}"
        next
      end
      business.backlink_datum.update_attributes(summary: response,
                                                summary_updated_at: Time.now)
    end
  end
end
