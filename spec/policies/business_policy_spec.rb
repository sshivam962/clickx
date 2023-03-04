# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessPolicy do
  before do
    @business = FactoryBot.create(:business)
  end

  it 'business should be visible to Agency Admin' do
    agency = FactoryBot.create(:agency)
    @business.update(agency_id: agency.id)
    agency_admin = FactoryBot.create(:agency_admin, ownable_id: agency.id, ownable_type: 'Agency')
    expect(described_class.new(agency_admin, @business).visible?).to eq(true)
  end

  it 'business should be visible to Company Admin' do
    company_admin = FactoryBot.create(:company_admin, ownable_id: @business.id, ownable_type: 'Business')
    expect(described_class.new(company_admin, @business).visible?).to eq(true)
  end

  it 'business should be managable by Agency Admin' do
    agency = FactoryBot.create(:agency)
    @business.update(agency_id: agency.id)
    agency_admin = FactoryBot.create(:agency_admin, ownable_id: agency.id, ownable_type: 'Agency')
    expect(described_class.new(agency_admin, @business).manage?).to eq(true)
  end

  it 'business should be managable by Super Admin' do
    super_admin = FactoryBot.create(:super_admin)
    expect(described_class.new(super_admin, @business).manage?).to eq(true)
  end

  it 'resources under business should be managable by business user' do
    user = FactoryBot.create(:user)
    @business.users << user
    expect(described_class.new(user, @business).client_level_manage?).to eq(true)
  end
end
