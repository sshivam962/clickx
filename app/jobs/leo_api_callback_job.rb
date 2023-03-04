# frozen_string_literal: true

class LeoApiCallbackJob
  include Sidekiq::Worker

  def perform(project_id)
    return if project_id.blank?
    ActiveRecord::Base.connection_pool.with_connection do
      leo_api_datum = LeoApiDatum.find_by(project_id: project_id)
      return if leo_api_datum.blank?

      business = leo_api_datum.business
      return if business.blank?

      leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
      response = leo_client.website_crawl_data(business.leo_project_id)
      business.leo_api_datum.update_crawl_data(response)
    end
  end
end
