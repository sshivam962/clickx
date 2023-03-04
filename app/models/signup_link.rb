class SignupLink < ApplicationRecord
  obfuscatable

  belongs_to :sales_rep, class_name: 'User', optional: true
  validates :onetime_charge, presence: true
  validates :plan_key, presence: true
  validates :trial_interval, presence: true, if: :trial?
  validates :trial_interval_count, presence: true, if: :trial?

  enum category: %i[agency business]
  enum discount_type: %i[coupon trial]

  after_commit :sync_with_hubspot, on: :create, if: -> { Rails.env.production? }

  TRIAL_INTERVALS = ['day', 'week', 'month', 'year'];

  scope :active, -> { where(disabled: [false, nil]) }

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def plan
    return Package.growth.plans.find_by(key: plan_key) if agency?

    Package.business_signup.plans.find_by(key: plan_key)
  end

  def url
    url_helper = Rails.application.routes.url_helpers
    return url_helper.agency_paid_url(tier: tier) if agency?

    url_helper.business_paid_url(tier: tier)
  end

  def enabled?
    !disabled?
  end

  def trial_info
    return unless trial?

    "#{trial_interval_count} #{trial_interval.pluralize(trial_interval_count)}"
  end

  def trial_end_from_now
    trial_interval_count.to_i.send(trial_interval).after.to_date
  end

  def trial_period_days
    return unless trial?

    (trial_end_from_now - Date.tomorrow).to_i
  end

  def expired?
    return false if expires_on.blank?

    if expires_on < Date.current
      if extended_count < 5
        self.expires_on += 3.days
        self.extended_count += 1
        save
        expires_on < Date.current
      else
        true
      end
    else
      false
    end
  end

  def calendly_script
    super || DEFAULT_SINGUP_LINK_CALENDLY_LINK
  end

  def paid?
    reusable_link? ? false : super
  end

  def paid
    reusable_link? ? false : super
  end

  private

  def tier
    "#{plan_key}-#{obfuscated_id}"
  end

  def sync_with_hubspot
    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: Rails.application.routes.url_helpers.auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    Hubspot::Contact.create_or_update(email, {
      email: email,
      firstname: first_name,
      lastname: last_name,
      payment_link_sent: 'Yes',
    }) if email.present?
  end
end
