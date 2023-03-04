# frozen_string_literal: true

require 'rails_helper'

describe 'Signing in', js: true do
  let(:super_admin) { create(:super_admin, email: 'admin@me.com', password: 'admin123', email: 'admin@gmail.com') }
  let(:company_admin) { create(:company_admin, email: 'company_admin@me.com', password: 'admin123') }
  let(:agency_admin) { create(:agency_admin, email: 'agency_admin@me.com', password: 'admin123') }

  xit 'Super user sign in with correct credentials' do
    visit root_path
    sign_in_with(super_admin.email, super_admin.password)
    expect(page).to have_content('admin@gmail.com')
  end

  xit 'Super user sign in with incorrect credentials' do
    visit root_path
    sign_in_with('hacker', '123456')
    expect(page).to have_content('Invalid Login or password')
  end

  xit 'Agency admin sign in with correct credentials' do
    visit root_path
    sign_in_with(agency_admin.email, agency_admin.password)
    expect(page).to have_title('Dashboard | Clickx')
  end

  xit 'Agency admin sign in with incorrect credentials' do
    visit root_path
    sign_in_with('agency_admin', '123456')
    expect(page).to have_content('Invalid Login or password')
  end

  # TODO: Company admin should not exist without a business
  xit 'Company admin sign in with correct credentials' do
    visit root_path
    sign_in_with(company_admin.email, company_admin.password)
    expect(page).to have_content('2017 Clickx')
  end

  xit 'Company admin sign in with incorrect credentials' do
    visit root_path
    sign_in_with(company_admin.email, '123456')
    expect(page).to have_content('Invalid Email or Password')
  end
end
