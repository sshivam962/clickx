# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgencyPolicy do
  before do
    @agency = FactoryBot.create(:agency)
  end

  it 'is visible to Agency Admin' do
    agency_admin = FactoryBot.create(:agency_admin, ownable_id: @agency.id, ownable_type: 'Agency')
    expect(described_class.new(agency_admin, @agency).visible?).to eq(true)
  end

  it 'is managable by Super Admin' do
    super_admin = FactoryBot.create(:super_admin)
    expect(described_class.new(super_admin, @agency).manage?).to eq(true)
  end
end
