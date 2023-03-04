# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SiteAuditIssue, type: :model do
  describe 'Association' do
    it { is_expected.to belong_to :leo_api_datum }
    it { is_expected.to have_one :site_audit_report }
  end
end
