# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgencyAdminBusinessEmailPreference, type: :model do
  it 'has valid factory' do
    expect(build(:agency_admin_business_email_preference)).to be_valid
  end
end
