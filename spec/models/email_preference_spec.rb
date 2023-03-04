# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailPreference, type: :model do
  context 'validations' do
    it { is_expected.to validate_inclusion_of(:key).in_array(EmailPreference::KEYS) }
    it { is_expected.to validate_inclusion_of(:feature).in_array(EmailPreference::FEATURES.keys) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:ownable) }
  end

  context 'recurring event type' do
    it 'marks preference as daily and monthly when both flags are set' do
      preference = create(:email_preference,
                          recurring: EmailPreference::RDAILY | EmailPreference::RMONTHLY,
                          feature: :reviews)
      expect(preference).to be_daily
      expect(preference).to be_monthly
      expect(preference).not_to be_weekly
    end
  end

  context 'Scopes' do
    let(:daily_preference) { create(:email_preference, recurring: EmailPreference::RDAILY) }

    it 'Include daily preferences in daily scope' do
      expect(EmailPreference.daily).to include(daily_preference)
      expect(EmailPreference.instant).not_to include(daily_preference)
    end
  end

  context 'Update data from console' do
    let (:business_with_users) { create(:business, :with_users) }

    it 'set_feature company: value; should only update the company and not its users' do
      EmailPreference.enable_for_feature(feature: :cookie_tracker,
                                         key: :form_submission_contact_mailer,
                                         business: business_with_users,
                                         enable: true)
      expect(business_with_users.email_preferences).not_to be_empty
      expect(business_with_users.users.first.email_preferences
        .where(key: :form_submission_contact_mailer)).to be_empty
    end

    it 'set_feature_microscope company: value; should only update the company and not its users' do
      business_email_preference = create(:email_preference,
                                         ownable: business_with_users.users.first,
                                         feature: 'clickx_tracker')
      EmailPreference.enable_feature_microscope(feature: business_email_preference.feature,
                                                key: business_email_preference.key,
                                                business: business_with_users,
                                                value: true,
                                                enable: true)
      # expect(business_with_users.email_preferences.first.feature_microscope).to be_truthy
      expect(business_with_users.users.first.email_preferences.first.feature_microscope).not_to be_truthy
    end

    skip 'It set_for_key company: value; should only update the company and not its users' do
      business_email_preference = create(:email_preference, ownable: business_with_users, key: 'new-key')
      user = business_with_users.users.first
      create(:email_preference, ownable: user, key: business_email_preference.key)
      EmailPreference.set_for_key(key: business_email_preference.key,
                                  business: business_with_users,
                                  value: true)
      expect(business_with_users.email_preferences.first.feature_microscope).to be_truthy
      expect(user.email_preferences.first.feature_microscope).not_to be_truthy
    end

    it 'set_feature user: value; should only update the user and not its company' do
      user = business_with_users.users.first
      EmailPreference.enable_for_feature(feature: :cookie_tracker,
                                         key: :form_submission_contact_mailer,
                                         user: user,
                                         enable: true)
      expect(business_with_users.email_preferences).to be_empty
      expect(user.email_preferences).not_to be_empty
    end

    it 'set_feature_microscope user: value; should only update the user and not its company' do
      user = business_with_users.users.first
      user_email_preference = create(:email_preference, ownable: user)
      create(:email_preference, ownable: business_with_users)
      EmailPreference.enable_feature_microscope(feature: user_email_preference.feature,
                                                key: user_email_preference.key,
                                                user: user,
                                                value: true,
                                                enable: true)
      expect(business_with_users.email_preferences.first&.feature_microscope).not_to be_truthy
      expect(user.email_preferences.last.feature_microscope).to be_truthy
    end

    skip 'set_for_key user: value; should only update the user and not its company' do
      user = business_with_users.users.first
      business_email_preference = create(:email_preference, ownable: user)
      create(:email_preference, ownable: user, key: business_email_preference.key)
      EmailPreference.set_for_key(key: business_email_preference.key,
                                  user: user,
                                  value: true)
      expect(business_with_users.email_preferences.first&.feature_microscope).not_to be_truthy
      expect(user.email_preferences.first.feature_microscope).to be_truthy
    end
  end
end
