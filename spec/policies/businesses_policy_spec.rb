# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BusinessesPolicy do
  it 'business list should be visible to Super Admin' do
    super_admin = FactoryBot.create(:super_admin)
    expect(described_class.new(super_admin, :businesses).visible?).to eq(true)
  end
end
