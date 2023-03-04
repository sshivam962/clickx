
# frozen_string_literal: true

require 'platform-api'
class Agency < ApplicationRecord
  acts_as_paranoid
  obfuscatable

  include AgencyAccessHelpers

  has_many :chat_threads
  has_many :lead_sources
  has_many :sent_emails, through: :lead_sources

  has_many :projects
  has_many :project_proposals, through: :projects
  has_many :agency_niches_accesses
  has_one :agency_profile
  has_many :fixed_plans
  has_many :plans, through: :fixed_plans

  has_many :businesses, before_add: :check_clients_limit, dependent: :destroy
  has_many :business_users, through: :businesses, source: :users
  has_many :users, as: :ownable, dependent: :destroy
  has_many :admins, as: :ownable, class_name: 'User'
  has_many :preview_users, -> { merge(User.preview) }, as: :ownable, class_name: 'User'
  has_many :normal_users, -> { merge(User.normal) }, as: :ownable, class_name: 'User'
  has_many :support_members, dependent: :destroy
  has_many :onboarding_procedures
  has_many :leads, dependent: :destroy, class_name: '::Lead'

  has_many :package_subscriptions, dependent: :destroy
  has_many :active_package_subscriptions,
           -> { merge(PackageSubscription.active) },
           class_name: 'PackageSubscription'
  has_many :growth_subscriptions,
           -> { merge(PackageSubscription.agency_infrastructure.active) },
           class_name: 'PackageSubscription'

  has_many :non_growth_subscriptions,
         -> { merge(PackageSubscription.non_growth.active.stripe) },
         class_name: 'PackageSubscription'

  has_many :grader_reports, as: :reportable, dependent: :destroy

  has_many :custom_packages

  has_many :agencies_courses
  has_many :courses, through: :agencies_courses

  has_many :subscription_schedules

  has_one :billing_address, as: :billing_addressable,
    foreign_type: :addressable_type, foreign_key: :addressable_id,
    class_name: 'BillingAddress', dependent: :destroy

  has_one :mailing_address, as: :mailing_addressable,
    foreign_type: :addressable_type, foreign_key: :addressable_id,
    class_name: 'MailingAddress', dependent: :destroy

  has_one :agreement, as: :agreementable, class_name: 'Agreement',
          dependent: :destroy
  has_one :addendum, dependent: :destroy
  has_one :stripe_credential
  has_many :payment_links

  has_many :deleted_agreements, -> { merge(Agreement.only_deleted) }, as: :agreementable, class_name: 'Agreement'

  has_many :todo_lists, dependent: :destroy

  has_many :agency_niches, dependent: :destroy, class_name: 'AgencyNiche'

  belongs_to :last_logged_in_user, class_name: 'User', foreign_key: :last_logged_in_user_id, optional: true

  belongs_to :referrer,
              class_name: 'User',
              foreign_key: :referred_by,
              optional: true

  has_many :case_studies

  has_many :portfolios

  has_many :documents
  has_many :outscrapper_requests, class_name: 'Outscrapper::Request'
  has_many :outscrapper_data, class_name: 'Outscrapper::Data'
  has_one :outscraper_limit, dependent: :destroy
  has_many :web_development, dependent: :destroy
  has_many :email_templates, dependent: :destroy
  has_many :funnel_pages, dependent: :destroy

  scope :white_labelled, -> { where.not(domain: nil) }
  scope :enabled, -> { where(agency_status: true) }
  scope :search_by_name, (lambda do |query|
    where("lower(name) ILIKE '%#{query.downcase}%'")
  end)

  enum level: %i[silver gold platinum titanium]

  # validates :name, presence: true, uniqueness: { case_sensitive: false}
  validates :name, presence: true

  validates :name_slug, uniqueness: { case_sensitive: false}
  validates :domain, uniqueness: { case_sensitive: false }, if: -> { domain.present? }
  validate :invalid_html, if: -> { facebook_pixel.present? }

  accepts_nested_attributes_for :outscraper_limit
  after_create :create_clickx_user

  after_commit :sync_to_home, on: :create
  after_commit :sync_users_to_hubspot, if: -> { Rails.env.production? }
  before_save :set_name_slug, if: proc { |agency|
    agency.name_slug.blank?
  }

  before_save do
    # if self.connect_call_link.blank?
    #   self.connect_call_link = 'https://www.clickx.io/success/connect/'
    # end

    if self.kickoff_call_link.blank?
      self.kickoff_call_link = 'https://calendly.com/marketing-meetings/kick-off-call'
    end

    # if self.prospecting_call_link.blank?
    #   self.prospecting_call_link = 'https://www.clickx.io/success/agency-prospecting-support'
    # end
  end

  before_save :update_white_label_domain, if: proc { |agency|
    agency.white_labeled_domain? && agency.changes_to_save['domain']
  }

  accepts_nested_attributes_for :support_members
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :mailing_address

  SERVICES = %w[
    local_profile_service seo_service call_analytics_service
    contents_service
    backlink_service site_audit_service
  ].freeze

  CACHE_DURATION = 60 * 15

  DEFAULT_DOMAIN = 'app.marketingportal.us'.freeze

  default_scope  { order(:name) }

  def as_json(options = {})
    super(options.merge(except: %i[created_at updated_at],
                        methods: %i[support_members_attributes]))
  end

  def check_clients_limit(_new_record)
    raise Exception, 'Client Limit Exceeded' if businesses.size >= clients_limit
  end

  def self.find_token(business_id)
    Token.where(code_type: Token::AnalyticsAccessToken)
         .where.not(access_token: nil)
         .find_by(business_id: business_id)
  end

  def self.find_enable_services(business)
    enable_services = []
    enable_services << 'Dashboard' << 'Contacts'
    enable_services << 'Google Ads' if business.google_ads_service?
    enable_services << 'Google Analytics' if business.google_analytics_service?
    enable_services << 'Keywords'
    enable_services
  end

  def preview_user
    users.preview
  end

  def outscraper_limit
    super || build_outscraper_limit
  end

  def create_clickx_user
    clickx_user = users.create(
      first_name: "#{name} Clickx",
      last_name: 'System User',
      preview_user: true,
      role: User::AgencyAdmin,
      invitation_sent_at: Time.current,
      invitation_accepted_at: Time.current,
      password: Devise.friendly_token.first(8),
      email: "agency.#{id}@xyz.io",
      agency_super_admin: true
    )
    clickx_user
  end

  def admins_with_email_preference(feature, key)
    if EmailPreference.default?(feature, key)
      admins
        .normal
        .where
        .not(id: admins.with_user_email_preference(feature, key, false).pluck(:id))
    else
      admins.with_user_email_preference(feature, key, true)
    end
  end

  def agency_profile
    super || create_agency_profile
  end

  def reply_to_email
    if support_email.present?
      "#{name}<#{support_email}>"
    else
      from_email
    end
  end

  def clickx?
    name.eql? 'Clickx'
  end

  def self.oneims
    find_by id: 3
  end

  def self.clickx
    find_by name: 'Clickx'
  end

  def from_email
    if clickx?
      'Clickx<support@clickx.io>'
    else
      "#{name}<noreply@marketingportal.us>"
    end
  end

  def remaining_keywords
    keywords_limit - businesses.sum(:keyword_limit)
  end

  def remaining_competitors
    competitors_limit - businesses.sum(:competitors_limit)
  end

  def white_labeled_domain?
    !!domain
  end

  def stripe_customer
    Stripe::Customer.retrieve(customer_id) if customer_id
  rescue Stripe::InvalidRequestError
    nil
  end

  def support_members_attributes
    support_members
  end

  def yext_creds
    {
      api_key: yext_api_key
    }
  end

  def verify_cname
    resolved_cname = Resolver(domain).answer[0].cname.delete_suffix(".")
    update_attributes(cname_verified: true) if resolved_cname == cname
  rescue
    errors.add(:base, 'CNAME Verification Failed')
  end

  def active_domain
    return domain if cname_verified?

    clickx? ? BASE_URL : DEFAULT_DOMAIN
  end

  def has_active_subscription?
    active_package_subscriptions
      .where("package_name LIKE 'agency_infrastructure%'")
      .present?
  end

  def active?
    return true if created_at > 3.months.ago
    return true if has_active_subscription?
    return true if businesses.count.positive?

    false
  end

  def inactive?
    !active?
  end

  def active_package
    active_package_subscriptions.agency_infrastructure.order(:created_at).last
  end

  def active_package_name
    active_package.present? ? active_package.package_name : nil
  end

  def stripe_active_package
    active_package_subscriptions.agency_infrastructure
                                .stripe
                                .order(:created_at)&.last
  end

  def label_list
    return [] if labels.blank?

    labels.split(',')
  end

  def grader_reports_percentage
    (this_month_grader_reports.size/grader_report_limit) * 100
  end

  def this_month_grader_reports
    grader_reports.where(
      created_at: Time.now.beginning_of_month..Time.now.end_of_month
    )
  end

  def fb_fixed_plan
    plans.find_by(package_type: 'fixed_facebook_ads')
  end

  def enabled_package?(package)
    enabled_packages.include?(package)
  end

  def agreement_signed?
    agreement&.signed? && (agreement.version.eql?('v2') || addendum&.signed?)
  end

  def addendum_signed?
    addendum&.signed?
  end

  def client_limit_exceeded?
    businesses.size >= clients_limit
  end

  def limited_access_to_portfolio?
    portfolio_limited_access? && !portfolio_enabled?
  end

  def limited_access_to_case_study?
    case_study_limited_access? && !case_study_enabled?
  end

  def access_to_coaching_course?
    courses.exists?(title: Course::COACHING_CALL_TITLE)
  end

  def dfyelite_remaining_days
    return if labels&.exclude?('DFYElite')
    return if created_at < 90.days.ago
    return if package_subscriptions.stripe.active.exists?

    90 - (Date.current - created_at.to_date).to_i
  end

  def this_month_strategies
    ::Lead::Strategy.includes(lead: :agency)
      .where(leads: {agencies: {id: id}})
      .where(
        created_at: Time.current.beginning_of_month..Time.current.end_of_month
      )
  end

  def white_labeled_domain
    return unless white_labeled?
    return unless cname_verified?
    return if domain.blank?

    domain
  end

  def abc?
    name.eql?('ABC Agency Services')
  end

  def self.abc
    Agency.find_by(name: 'ABC Agency Services')
  end

  def self.whitelabeled_domains
    where(
      cname_verified: true,
      white_labeled: true
    ).where.not(domain: EMPTY).pluck(:domain)
  end

  private

  def heroku
    @_heroku ||= PlatformAPI.connect_oauth(ENV['HEROKU_APP_TOKEN'])
  end

  def update_white_label_domain
    self.cname_verified &&= false
    response = heroku.domain.create(
      ENV['HEROKU_APP_NAME'], hostname: domain, sni_endpoint: nil
    )
    self.cname = response['cname']
    response
  rescue Excon::Error::UnprocessableEntity, Excon::Error::NotFound
    errors.add(:base, 'Unable to register domain')
  end

  def set_name_slug
    i = 0
    self.name_slug = loop do
      random_slug = name.parameterize
      random_slug += "-#{i}" if i.positive?
      i = i + 1
      break random_slug unless Agency.exists?(name_slug: random_slug)
    end
  end

  def sync_to_home
    SyncAgencyToHomeJob.perform_later(self.id)
  end

  def sync_users_to_hubspot
    return if labels.blank?
    return unless saved_change_to_labels?
    return unless labels.include?('DFYElite')

    users.normal.map(&:sync_with_hubspot)
  end

  def invalid_html
    begin
      Nokogiri::XML(facebook_pixel) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError => e
      errors.add(:facebook_pixel, "Invalid HTML: #{e}")
    end
  end
end
