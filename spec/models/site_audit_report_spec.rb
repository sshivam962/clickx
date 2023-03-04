# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SiteAuditReport, type: :model do
  describe 'Association' do
    it { is_expected.to belong_to :site_audit_issue }
  end
end
