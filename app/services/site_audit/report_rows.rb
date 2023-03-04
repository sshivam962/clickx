# frozen_string_literal: true

module SiteAudit
  class ReportRows < Struct.new(:business, :params)
    URL = "#{ROOT_URL}/businesses/site_audits/"

    def self.call(business, params)
      new(business, params).call
    end

    attr_accessor :payload

    def call
      return error_msg('Could not find site audit service') \
        unless business.site_audit_service
      if business.leo_api_datum
        return error_msg('No data found') unless params['url'] && params['issue_id']
        return site_audit_report(business.leo_api_datum, params)
      else
        return error_msg('Detailed report not found')
      end
    end

    def success?
      status != :failed
    end

    private

    attr_accessor :status

    def site_audit_report(data, params)
      issue = data.site_audit_issues.find(params['issue_id'])
      report_data = SiteAuditReport.where(site_audit_issue_id: issue)
      return error if report_data.blank?
      report = SiteAuditReport.where(site_audit_issue_id: issue).select(:title, :description, :h_tags, :images, :cta, :page_links)
                              .as_json[0]
                              .except!('id')
      set_issue_type(report)
      report_array = []
      report_array << report
      updated_at = business.leo_api_datum.updated_at.strftime('%A, %B %d, %Y')
      self.payload = {
        data: report_array,
        errors_count: issue.errors_count,
        warning_count: issue.warning_count,
        passed: issue.passed_count,
        updated_at: updated_at,
        url: "#{URL}#{business.id}/leo_report_rows.csv?url=#{params['url']}"
      }
      self
    end

    def error_msg(msg)
      self.payload = { error: msg }
      self.status = :failed
      self
    end

    def add_description(hash)
      return unless hash['status']
      content = SiteAuditIssueInfo.where(issue_type: hash['issue_type']).first
      if content
        hash['error_description'] = content.error_description
        hash['passed_description'] = content.passed_description
        hash['error_title'] = content.error_title
        hash.merge!('passed_title' => content.passed_title)
      else
        hash['error_description'] = nil
        hash['passed_description'] = nil
        hash['error_title'] = nil
        hash.merge!('passed_title' => nil)
      end
    end

    def error
      self.payload = {
        error: 'This page on your site might not be crawled, or blocked our crawler.'
      }
      self
    end

    def set_issue_type(report)
      report.each_value do |value|
        next if value.blank? || value['data'].blank?
        value['data'].each do |hash|
          hash.merge!(add_description(hash))
        end
      end
    end
  end
end
