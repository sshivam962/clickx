# frozen_string_literal: true
class SiteAuditIssue < ApplicationRecord
  belongs_to :leo_api_datum
  has_one :site_audit_report, dependent: :destroy
  validates :page_id, presence: true, uniqueness: true
end
