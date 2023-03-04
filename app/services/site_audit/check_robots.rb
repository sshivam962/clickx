# frozen_string_literal: true

module SiteAudit
  class CheckRobots < Struct.new(:business)
    def self.call(business)
      new(business).call
    end

    attr_accessor :payload

    def call
      return error_msg('Could not find site_audit_service') \
        unless business.site_audit_service
      if business.leo_api_datum&.check_robots
        return data(business.leo_api_datum.check_robots)
      else
        return error_msg('data not found')
      end
    end

    def success?
      status != :failed
    end

    private

    attr_accessor :status

    def data(data)
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
