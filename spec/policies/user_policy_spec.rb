# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserPolicy do
  it 'allows destroy user for Company Admin' do
    business = FactoryBot.create(:business)
    business.users << FactoryBot.create(:user)
    company_admin = FactoryBot.create(:company_admin, ownable: business)
    expect(described_class.new(company_admin, business.users.first).can_destroy?).to eq(true)
  end

  it 'allows destroy user for Company Admin of another business where user belongs to' do
    business1 = FactoryBot.create(:business)
    business2 = FactoryBot.create(:business)
    user = FactoryBot.create(:user)
    business1.users << user
    business2.users << user
    company_admin = FactoryBot.create(:company_admin)
    business2.users << company_admin
    expect(described_class.new(company_admin, user).can_destroy?).to eq(true)
  end

  it 'allows destroy user for Super Admin' do
    business = FactoryBot.create(:business)
    business.users << FactoryBot.create(:user)
    super_admin = FactoryBot.create(:super_admin)
    expect(described_class.new(super_admin, business.users.first).can_destroy?).to eq(true)
  end
end
