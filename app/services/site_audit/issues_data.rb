# frozen_string_literal: true

module SiteAudit
  class IssuesData < Struct.new(:business, :params)
    def self.call(business, params)
      new(business, params).call
    end

    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"

    attr_accessor :payload

    def call
      return error_msg('Could not find site_audit_service') \
        unless business.site_audit_service
      return update_leo_project unless leo_api_datum.project_id
      if leo_api_datum&.project_id
        return crawling_in_progress if leo_api_datum.site_audit_issues.blank?
        data = fetch_issues_data
        total_size = leo_api_datum.site_audit_issues.count
        return issues_data(data, total_size,
                           leo_api_datum.updated_at)
      end
    end

    def success?
      status != :failed
    end

    private

    attr_accessor :status

    def issues_data(data, total_size, updated_at)
      self.payload = { data: data,
                       total_size: total_size,
                       updated_at: updated_at.strftime('%A, %B %d, %Y') }
      self.status = :success
      self
    end

    def error_msg(msg)
      self.payload = { error: msg }
      self.status = :failed
      self
    end

    def leo_api_datum
      @_leo_api_datum ||= business.leo_api_datum || business.create_leo_api_datum
    end

    def create_leo_project
      leo_client.create_project(business.domain, CALLBACK_URL, keywords, urls, business.total_pages_crawled)
    end

    def update_leo_project
      response = create_leo_project
      if response.key?('errors')
        log_info(response.as_json)
        log_info(response['errors'])
        error_msg(response['errors'])
      else
        project_id = response.fetch('id', nil)
        update_business(project_id)
        crawling_in_progress
      end
    end

    def urls
      latest_data = Businesses::KeywordRanks.fetch(business, {})
      keyword_urls = latest_data.pluck('googleRankingUrl').compact
      backlinks = business&.backlink_datum&.backlinks
                          &.pluck('TargetURL')&.compact
      keywords = business.keywords.pluck(:name)
      urls = (keyword_urls + [backlinks]).uniq.compact
      site_urls = urls.map do |url|
        url.split('://').last
      end.uniq.compact
    end

    def keywords
      @_keywords ||= business.keywords.pluck(:name)
    end

    def update_business(project_id)
      return unless project_id
      business.update_attributes(leo_project_id: project_id)
      leo_api_datum.update_attributes(project_id: project_id,
                                      last_crawl_created_at: Time.current)
    end

    def leo_client
      @_leo_client ||= LeoApi.new(ENV['LEO_API_TOKEN'])
    end

    def crawling_in_progress
      self.payload = { message: 'Crawling in progress. Please try again later' }
      self.status = :failed
      self
    end

    def fetch_issues_data
      if params[:search]
        leo_api_datum.site_audit_issues.where("url LIKE ?", "%#{params[:search]}%")
      else
        if params[:limit].to_i == 1
          leo_api_datum.site_audit_issues
        elsif params[:limit] && params[:offset]
          leo_api_datum.site_audit_issues.drop(params[:offset].to_i).first(params[:limit].to_i)
        else
          leo_api_datum.site_audit_issues
        end
      end
    end

    def log_info(msg)
      # Rollbar.info(msg)
    end
  end
end
