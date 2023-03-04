# frozen_string_literal: true

class LeoApiDatum < ApplicationRecord
  validates :business_id, presence: true
  belongs_to :business
  has_many :site_audit_issues, dependent: :destroy

  enum crawl_status: %i[crawling crawl_completed]

  def update_crawl_data(params)
    attributes = params.slice('ssl_presence',
                              'xml_sitemap', 'version_check',
                              'check_robots')
    update(attributes.merge({ last_crawl_created_at: Time.current }))
  end

  def update_site_audit_issue_data(params, page_id)
    issue_data = params.dig('issues_data')
    return if issue_data.nil?
    issue_attribute = issue_data.slice('url', 'errors_count', 'warning_count', 'readability_score', 'readability_note')
    site_audit_issues.where(page_id: page_id).update(issue_attribute)
    detailed_report = params&.slice('page_detailed_report')
    map_issue_data(issue_attribute, page_id)
    map_detail_data(detailed_report, page_id)
  end

  def map_issue_data(issue_data, page_id)
    backlinks = get_backlinks(business.backlink_datum&.backlinks)
    latest_data = Businesses::KeywordRanks.fetch(business, {})
    keywords = get_keywords(latest_data)
    url = issue_data.dig('url').split('://').last
    backlinks_count = backlinks_count(url, backlinks)
    keyword = keyword_count(url, keywords)
    traffic = url_visits(issue_data.dig('url'))
    site_audit_issues.where(page_id: page_id)
                     .update(backlinks_count: backlinks_count,
                             keywords: keyword, traffic_metrics: traffic)
  end

  def map_detail_data(detailed_report, page_id)
    return if (detailed_report.nil? || detailed_report["page_detailed_report"].blank?)
    report_attribute = detailed_report["page_detailed_report"].values[0]
                                                              .slice('title', 'description',
                                                                     'h_tags', 'images',
                                                                     'cta', 'page_links')
    issue = site_audit_issues.find_by(page_id: page_id)
    passed_count(report_attribute, issue)
    SiteAuditReport.where(site_audit_issue_id: issue.id).update(report_attribute)
  end

  private

  def backlinks_count(url, backlinks)
    if backlinks[url]
      backlinks[url].count
    else
      0
    end
  end

  def keyword_count(url, keywords)
    if keywords[url]
      keywords[url].count
    else
      0
    end
  end

  def url_visits(url)
    if traffic_metrics
      visit = traffic_metrics.select { |path, _value| path == URI(url).path }
      visit.flatten[1].to_i
    else
      0
    end
  end

  def traffic_metrics
    @_traffic_metrics ||=
      GoogleAnalytics::TrafficMetrics.new(business).fetch
  end

  def get_backlinks(backlinks_data)
    if backlinks_data
      backlinks_data.group_by { |d| d['TargetURL'].split('://').last }
    else
      {}
    end
  end

  def get_keywords(latest_data)
    if latest_data
      latest_data.reject { |d| d['googleRankingUrl'].nil? }
                 .group_by { |d| d['googleRankingUrl'].split('://').last }
    else
      {}
    end
  end

  def passed_count(report, issue)
    count = 0
    details = %w[title description h_tags images cta page_links]
    details.each do |detail|
      report.fetch(detail, {}).fetch('data', []).each do |data|
        count += 1 if data['status'] == 'passed'
      end
    end
    issue.update(passed_count: count)
  end
end
