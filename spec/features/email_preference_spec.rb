# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Email Preference', type: :feature do
  let(:company_admin) { create(:company_admin, password: 'admin123') }

  it 'User create a new preference' do
    i_am_logged_in_as_user
    when_i_goto_my_email_settings_page
    then_i_should_see_page_with_email_preference
    all_preferences_should_be_empty_by_default
    when_i_enable_review_updates
    i_should_see_updated_message
  end

  it 'agency admin create a new preference' do
  end

  def i_am_logged_in_as_user
    # login_as(company_admin, scope: :user)
    sign_in_with(company_admin.email, 'admin123')
  end

  def when_i_goto_my_email_settings_page
    visit email_settings_user_path(company_admin)
  end

  def then_i_should_see_page_with_email_preference
    expect(page).to have_text('Email Preferences')
  end

  def all_preferences_should_be_empty_by_default
    # all('.email_preference_enabled > div > input').each do |input|
    #   expect(input).to be_disabled?
    # end
  end

  def when_i_enable_review_updates
    # find('#review_updates_email_preference_enabled').click
  end

  def i_should_see_updated_message
    # expect(page).to have_content('Successfully updated')
  end
end
