# frozen_string_literal: true

class EmailPreference < ApplicationRecord
  belongs_to :ownable, polymorphic: true

  # FEATURES - a constant to keep the internal representation of each FEATURES
  BUSINESS_FEATURES = {
    reviews: {
      mailers: {
        review_updates: {
          name: 'Updates',
          hint: 'Notification e-mail whenever a new review is added by the user',
          default: false
        }
      }
    },
    reports: {
      mailers: {
        weekly_report: {
          name: 'Weekly E-mail',
          hint: 'If you want to receive weekly reports about the activities',
          default: false
        },
        weekly_competitor_report: {
          name: 'Weekly competitiors report',
          hint: 'Weekly mail about potential competitors and their keywords',
          default: false
        }
      }
    }
  }.freeze

  AGENCY_FEATURES = {
    business_reports: {
      mailers: {
        business_performance_report: {
          name: 'Business performance report',
          hint: 'Monthly report of business about various performance metrics',
          default: true
        }
      }
    }
  }.freeze

  FEATURES = BUSINESS_FEATURES.merge(AGENCY_FEATURES)
  KEYS = EmailPreference::FEATURES.values.collect(&:values).flatten.collect(&:keys).flatten.freeze

  RINSTANT =   0b00000001
  RDAILY   =   0b00000010
  RWEEKLY  =   0b00000100
  RMONTHLY =   0b00001000

  scope :daily, -> { where("recurring::bit(8) & #{EmailPreference::RMONTHLY}::bit(8) <> 0::bit(8)") }
  scope :instant, -> { where("recurring::bit(8) & #{EmailPreference::RINSTANT}::bit(8) <> 0::bit(8)") }
  scope :daily, -> { where("recurring::bit(8) & #{EmailPreference::RDAILY}::bit(8) <> 0::bit(8)") }
  scope :monthly, -> { where("recurring::bit(8) & #{EmailPreference::RMONTHLY}::bit(8) <> 0::bit(8)") }
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(disabled: true) }

  validates :key, inclusion: { in: KEYS.map(&:to_s) }
  validates :feature, inclusion: { in: FEATURES.keys.map(&:to_s) }
  validates :key, uniqueness: { scope: %i[feature ownable_id ownable_type] }

  def daily?
    (recurring & RDAILY) != 0
  end

  def instantly?
    (recurring & RINSTANT) != 0
  end

  def weekly?
    (recurring & RWEEKLY) != 0
  end

  def monthly?
    (recurring & RMONTHLY) != 0
  end

  def enabled?
    return EmailPreference::FEATURES[feature.to_sym][:mailers][key.to_sym][:default] if new_record?
    super
  end

  def enable!
    update!(enabled: true)
  end

  def self.default?(feature, key)
    EmailPreference::FEATURES.dig(feature.to_sym, :mailers, key.to_sym, :default) || false
  end

  def self.enable_for_feature(feature:, enable:, user: nil, business: nil, key:, agency_admin_business: nil)
    if user
      preferences = user.email_preferences.find_or_create_by(feature: feature, key: key)
      preferences.update_attributes(enabled: enable)
    end

    if business
      preferences = business.email_preferences.find_or_create_by(feature: feature, key: key)
      preferences.update_attributes(enabled: enable)
    end

    if agency_admin_business
      preferences = agency_admin_business.email_preferences.find_or_create_by(feature: feature, key: key)
      preferences.update_attributes(enabled: enable)
    end
  end

  def self.enable_feature_microscope(feature:, value:, user: nil, business: nil, key:, enable: true)
    if user
      preference = user.email_preferences.where(feature: feature)
      preference.update_all(feature_microscope: enable)
    end

    if business
      preference = business.email_preferences.where(feature: feature)
      preference.update_all(feature_microscope: enable)
    end
  end

  def self.set_for_key(key:, value:, user: nil, business: nil)
    user&.email_preferences&.where(key: key)
        &.first&.update_attributes(feature_microscope: true)
    business&.email_preferences&.where(key: key)
            &.first&.update_attributes(feature_microscope: true)
  end

  def self.fetch_status(feature:, key:, user:, business:)
    if user
      preference =
        user.email_preferences.where(feature: feature, key: key) ||
        user.business.email_preferences.where(feature: feature, key: key)
    elsif business
      prefernce = business.email_preferences.where(feature: feature, key: key)
    end
    preference.enabled? && prefernce.feature_microscope
  end
end
