# frozen_string_literal: true

class SiteAuditCallbackJob
  include Sidekiq::Worker

  sidekiq_options queue: 'site_audit_callback_queue'

  def perform(project_id, page_id)
    return if project_id.blank?
    return if page_id.blank?

    ActiveRecord::Base.connection_pool.with_connection do
      leo_api_datum = LeoApiDatum.find_by(project_id: project_id)
      return if leo_api_datum.blank?

      business = leo_api_datum.business
      return if business.blank?

      leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
      response = leo_client.page_crawl_data(page_id)
      issue = SiteAuditIssue.find_or_create_by(page_id: page_id,
                                               leo_api_datum_id: leo_api_datum.id)
      SiteAuditReport.find_or_create_by(site_audit_issue_id: issue.id)
      business.leo_api_datum.update_site_audit_issue_data(response, page_id)
    end
  end
end
