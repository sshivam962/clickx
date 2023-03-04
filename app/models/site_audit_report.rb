# frozen_string_literal: true
class SiteAuditReport < ApplicationRecord
  belongs_to :site_audit_issue
end
