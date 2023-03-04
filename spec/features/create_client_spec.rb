# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'create client' do
  let(:super_admin) { create(:super_admin, email: 'admin@me.com', password: 'admin123') }
  let(:agency) { create(:agency) }

  # TODO: Client creation from super admin ui is removed, make this from agency
  xit 'create client as super admin', js: true do
    i_am_logged_in_as_super_user
    i_should_see_create_client_button
    when_i_click_on_the_create_button
    i_should_see_add_new_client
    i_fill_the_form
    i_should_see_business_in_the_list
  end

  def i_am_logged_in_as_super_user
    sign_in_with(super_admin.email, 'admin123')
  end

  def i_should_see_create_client_button
    expect(page).to have_text('Create Client')
  end

  def when_i_click_on_the_create_button
    agency
    click_link 'Create Client'
  end

  def i_should_see_add_new_client
    expect(page).to have_text('Add New Client')
  end

  def i_should_see_business_in_the_list
    expect(page).to have_text('Tachyons')
  end

  def i_fill_the_form
    fill_in 'name', with: 'Tachyons'
    fill_in 'domain_name', with: 'aboobacker.in'
    fill_in 'target_city', with: 'Chickago'
    fill_in 'keyword_limit', with: 11
    select(agency.name, from: 'agency_id')
    click_button 'Save Client'
  end
end
