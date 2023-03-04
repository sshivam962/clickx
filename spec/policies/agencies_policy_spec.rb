# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgenciesPolicy do
  it 'lists agencies to Super Admin' do
    super_admin = FactoryBot.create(:super_admin)
    expect(described_class.new(super_admin, :agencies).visible?).to eq(true)
  end
end
