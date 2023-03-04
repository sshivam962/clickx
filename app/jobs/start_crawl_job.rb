# frozen_string_literal: true

class StartCrawlJob
  include Sidekiq::Worker

  def perform(business_id)
    ActiveRecord::Base.connection_pool.with_connection do
      business = Business.find_by(id: business_id)
      return if business.blank?

      leo_api_datum ||= business.leo_api_datum || business.create_leo_api_datum
      return if leo_api_datum.project_id.present?

      leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
      response =
        leo_client.create_project(
          business.domain,
          callback_url,
          keywords(business),
          urls(business),
          business.total_pages_crawled
        )

      if response.key?('errors')
        leo_api_datum.update_attributes(error_response: response['errors'][0])
      else
        project_id = response.fetch('id', nil)
        business.update_attributes(leo_project_id: project_id)
        leo_api_datum.update_attributes(project_id: project_id,
                                        last_crawl_created_at: Time.current)
      end
    end
  end

  private

  def callback_url
    "#{ROOT_URL}/businesses/leo_audit_callback.json"
  end

  def keywords(business)
    @_keywords ||= business.keywords.pluck(:name)
  end

  def urls(business)
    backlinks = []
    latest_data = Businesses::KeywordRanks.fetch(business, {})
    keyword_urls = latest_data.pluck('googleRankingUrl').compact
    backlink_datum = business.backlink_datum
    backlinks = backlink_datum.backlinks.pluck('TargetURL').compact \
                  if backlink_datum&.backlinks
    urls = (keyword_urls + backlinks).uniq.compact

    urls.map do |url|
      url.split('://').last
    end.uniq.compact
  rescue StandardError
    nil
  end
end
