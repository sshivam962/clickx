# frozen_string_literal: true

module SiteAudit
  class VersionCheck < Struct.new(:business)
    def self.call(business)
      new(business).call
    end

    attr_accessor :payload

    def call
      return error_msg('Could not find site_audit_service') \
        unless business.site_audit_service

      if business.leo_api_datum&.project_id
        if business.leo_api_datum.version_check
          return version_check(business.leo_api_datum.version_check)
        else
          return error_msg('Crawling in progress. Please try again later')
        end
      else
        return error_msg('Not created any project')
      end
    end

    def success?
      status != :failed
    end

    private

    attr_accessor :status

    def version_check(data)
      self.payload = { data: data }
      self
    end

    def error_msg(msg)
      self.payload = { error: msg }
      self.status = :failed
      self
    end
  end
end
