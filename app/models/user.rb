# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  acts_as_paranoid

  has_merit
  has_secure_token

  include UniqueId
  include Mailchimp
  include Close

  Admin        = 'admin'
  CompanyAdmin = 'company_admin'
  CompanyUser  = 'company_user'
  AgencyAdmin  = 'agency_admin'
  Contractor   = 'contractor'
  Roles = [Admin, CompanyAdmin, CompanyUser, AgencyAdmin, Contractor].freeze

  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :masqueradable,
         :validatable, :timeoutable, :lastseenable,
         :invitable, validate_on_invite: true

  validates :role, inclusion: {
    in: Roles,
    message: 'not a valid role'
  }

  validates :first_name, presence: true
  validates :email, uniqueness: true

  before_create :assign_unique_id
  after_create :associate_ownable, unless: :super_admin?
  after_create :create_default_email_preferences, if: :business_user?
  after_create :perform_mailchimp_add_job

  before_create :set_referral_code

  after_commit :sync_with_hubspot, on: :create
  after_commit :sync_with_closeio, on: :create

  before_validation do
    normalize_name
  end

  def normalize_name
    self.first_name&.strip!
    self.last_name&.strip!
  end

  has_many :chat_threads, dependent: :destroy
  has_many :send_user, class_name: 'Twillio::Message', foreign_key: :user_id, dependent: :destroy
  has_many :project_proposals, dependent: :destroy

  has_one :network_profile, dependent: :destroy
  has_one :web_development, dependent: :destroy
  accepts_nested_attributes_for :network_profile, allow_destroy: true

  has_many :email_preferences, as: :ownable, dependent: :destroy
  has_many :locations
  has_many :businesses_users
  has_many :content_orders
  has_many :businesses, through: :businesses_users

  has_many :admin_payment_links
  belongs_to :ownable, polymorphic: true, optional: true
  belongs_to :ownable_business,
             -> { includes(:users).where(users: { ownable_type: 'Business' }) },
             foreign_key: 'ownable_id', class_name: 'Business', optional: true
  belongs_to :ownable_agency,
             -> { includes(:users).where(users: { ownable_type: 'Agency' }) },
             foreign_key: 'ownable_id', class_name: 'Agency', optional: true

  has_many :notifications, dependent: :destroy
  has_many :webpush_subscriptions, dependent: :destroy
  has_many :agency_admin_business_email_preferences, dependent: :destroy
  has_many :agency_admin_email_preferences,
           through: :agency_admin_business_email_preferences,
           class_name: 'EmailPreference',
           source: :email_preferences

  has_many :watch_histories, dependent: :destroy
  has_many :watched_chapters,
           through: :watch_histories,
           class_name: 'Chapter',
           source: 'chapter'

  has_many :completed_action_steps, dependent: :destroy
  has_many :checked_action_steps,
          through: :completed_action_steps,
          class_name: 'ActionStep',
          source: 'action_step'

  has_many :referred_agencies,
           foreign_key: :referred_by,
           class_name: 'Agency'

  has_many :favorite_industries, dependent: :destroy
  has_many :favorited_industries, through: :favorite_industries, class_name: 'Industry', source: :industry

  has_many :favorite_courses, dependent: :destroy
  has_many :favorited_courses, through: :favorite_courses, class_name: 'Course', source: :course

  has_many :case_studies, dependent: :nullify, foreign_key: :assignee_id
  has_many :favorite_case_studies, dependent: :destroy
  has_many :favorited_case_studies, through: :favorite_case_studies, class_name: 'CaseStudy', source: 'case_study'

  has_many :package_subscriptions, through: :referred_agencies

  has_many :users_courses
  has_many :courses, through: :users_courses

  has_many :lead_contacts_emailed_today,
           -> { merge(SentEmail.contacted_today) },
           class_name: 'SentEmail',
           foreign_key: :sender_id
  has_many :lead_contacts_emailed_yesterday,
           -> { merge(SentEmail.contacted_yesterday) },
           class_name: 'SentEmail',
           foreign_key: :sender_id

  has_many :lead_contacts_verified_today,
           -> { merge(SentEmail.verified_today) },
           class_name: 'SentEmail',
           foreign_key: :verified_by
  has_many :lead_contacts_verified_yesterday,
           -> { merge(SentEmail.verified_yesterday) },
           class_name: 'SentEmail',
           foreign_key: :verified_by

  has_many :identities

  has_many :outscrapper_request,
           foreign_key: :created_by,
           class_name: 'Outscrapper::Request'

  accepts_nested_attributes_for :email_preferences
  accepts_nested_attributes_for :identities

  delegate :network_membership, to: :network_profile, allow_nil: true

  scope :preview, -> { where(preview_user: true) }
  scope :normal, -> { where(preview_user: false) }
  scope :contractors, -> { where(role: 'contractor') }
  scope :active, -> { invitation_accepted.or(preview) }
  scope :admin_users, -> { where.not(invitation_accepted_at: nil).where(role: User::Roles.first) }
  scope :agency_admins, -> { where.not(invitation_accepted_at: nil).where(role: User::AgencyAdmin) }
  scope :admins_mailing_list, -> { admin_users.where(email_alert: true) }
  scope :business_users_mailing_list, -> { where.not(invitation_accepted_at: nil, preview_user: true) }
  scope :with_user_email_preference, ->(feature, key, enabled) {
    joins(:email_preferences)
      .normal
      .where(email_preferences: {
               key: key,
               feature: feature,
               enabled: enabled
             })
  }

  scope :with_agency_admin_email_preference, ->(feature, key, enabled) {
    joins(agency_admin_business_email_preferences: :email_preferences)
      .normal
      .where(preview_user: false,
             email_preferences: {
               key: key,
               feature: feature,
               enabled: enabled
             })
  }

  scope :with_default_email_preference, ->(feature, key) {
    where("#{EmailPreference::FEATURES[feature.to_sym][:mailers][key.to_sym][:default]} = true")
  }

  # scope :with_business_email_preference, ->(feature, key) {
  #  joins(ownable_business: :email_preferences)
  #    .where(email_preferences: { feature: feature, key: key})
  # }

  scope :with_email_preference_enabled, ->(feature, key) {
    with_default_email_preference(feature, key)
      .where(preview_user: false)
      .union(with_user_email_preference(feature, key, true))
  }

  def self.with_email_preference(feature, key)
    with_email_preference_enabled(feature, key) - with_user_email_preference(feature, key, false)
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split.first
      user.last_name = auth.info.name.split[1..-1].join(' ')
    end
  end

  def self.email_exists?(email)
    where('lower(email) = ?', email.downcase).exists?
  end

  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def with_authy_authentication?(request)
    whitelisted_ip?(request.remote_ip) ? false : super
  end

  def as_json(options = {})
    if options[:basic]
      data = super(options.merge(only: %i[id email first_name preview_user invitation_sent_at last_seen]))
    elsif options[:super]
      data = super(options)
    else
      data = super(options.merge(only: %i[email sign_in_count role
                                          last_seen invitation_sent_at
                                          invitation_accepted_at id
                                          first_name last_name user_name
                                          email_alert preview_user full_access
                                        ]))

      data = data.merge(is_fb_token: fb_token?,
                        is_twitter_token: twitter_token?,
                        is_linkedin_token: linkedin_token?,
                        is_googleplus_token: googleplus_token?)
    end
    data
  end

  # we are keeping business_id for knowing to which business user is invited to
  # so as to show proper images in email & associate him with that business
  def fb_token?
    fb_access_token ? true : false
  end

  def twitter_token?
    twitter_access_token ? true : false
  end

  def linkedin_token?
    linkedin_access_token ? true : false
  end

  def googleplus_token?
    google_plus_access_token ? true : false
  end

  def associate_ownable
    if ownable_id
      ownable = self.ownable
      ownable.users << self unless ownable.users.include?(self)
    end
  end

  DEPARTMENT_INFO = [
    {
      name: 'Marketing',
      key: 'marketing'
    },
    {
      name: 'Leadership',
      key: 'leadership'
    },
    {
      name: 'Finance',
      key: 'finance'
    },
    {
      name: 'Management',
      key: 'management'
    },
    {
      name: 'Customer Fulfillment',
      key: 'customer_fulfillment'
    },
    {
      name: 'Lead Conversion',
      key: 'lead_conversion'
    },
    {
      name: 'Lead Generation',
      key: 'lead_generation'
    },
    {
      name: 'Apprenticeship',
      key: 'apprenticeship'
    },
    {
      name: 'Appointment Setter',
      key: 'appointment_setter'
    }
  ]

  def self.department_collection
    DEPARTMENT_INFO.map { |ci| [ci[:name].upcase, ci[:key]] }
  end

  def contractor?
    role == Contractor
  end

  def super_admin?
    role == Admin
  end

  def business_user?
    company_admin? || company_user?
  end

  def agency_user?
    agency_admin?
  end

  def company_admin?
    role == CompanyAdmin
  end

  def company_user?
    role == CompanyUser
  end

  def agency_admin?
    role == AgencyAdmin
  end

  def any_admin?
    super_admin? || agency_admin?
  end

  def initials
    [first_name[0], last_name[0]].join.upcase
  end

  def name
    [first_name, last_name].join(' ')
  end

  def email_md5
    Digest::MD5.hexdigest(email.downcase)
  end

  def header_customer_id(current_business_unique_id)
    if super_admin?
      unique_id
    else
      [current_business_unique_id, unique_id].join(' - ')
    end
  end

  def add_to_mailchimp
    return true unless Rails.env.production?
    add_to_list(self, ENV['MAILCHIMP_ALL_LIST_ID'])
    if ownable.try(:trial_service)
      add_to_list(self, ENV['MAILCHIMP_TRIAL_LIST_ID'])
    else
      add_to_list(self, ENV['MAILCHIMP_NEW_LIST_ID'])
    end
  end

  def remove_from_mailchimp
    return true unless Rails.env.production?
    remove_from_list(self, ENV['MAILCHIMP_ALL_LIST_ID'])
    if ownable.try(:trial_service)
      remove_from_list(self, ENV['MAILCHIMP_TRIAL_LIST_ID'])
    else
      remove_from_list(self, ENV['MAILCHIMP_NEW_LIST_ID'])
    end
  end

  def perform_mailchimp_add_job
    MailchimpAddUserJob.perform_async(self) if !super_admin? && !preview_user? && !agency_admin?
  end

  def add_to_closeio
    create_lead parameterize_lead(self)
  rescue StandardError
  end

  # added this method as described in devise documents
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  # to allow sign in using either email or username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(['lower(email) = :value', { value: login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def whitelisted_ip?(ip_address)
    IpAddress.exists?(ip: ip_address)
  end

  def normal?
    !preview_user
  end

  def clickx?
    businesses.map(&:clickx?).include?(true)
  end

  def from_email
    if super_admin? || agency_admin? || (business_user? && clickx?)
      'Clickx<support@clickx.io>'
    elsif businesses.count == 1
      businesses.first.from_email
    else
      'noreply@marketingportal.us'
    end
  end

  def create_default_email_preferences
    email_preferences.create(feature: 'reports', key: 'weekly_report')
  end

  def set_referral_code
    return if contractor?

    self.referral_code = generate_unique_code
    self.referral_link = ReferralCode.agency_referral_link(referral_code)
  end

  def generate_unique_code
    loop do
      code = ReferralCode.generate
      break code unless User.exists?(referral_code: code)
    end
  end

  def ownable_businesses
    if super_admin?
      Business.all.select(:id, :name).as_json(super: true)
    else
      ownable_agency.businesses.select(:id, :name).as_json(super: true)
    end
  end

  def clickx_admin?
    email.eql?('admin@clickx.io')
  end

  def self.permission_collection
    [
      ['Admin Academy', 'admin_academy'],
      ['Admin Users', 'admin_users'],
      ['Agencies', 'agencies'],
      ['Agency Academy', 'agency_academy'],
      ['Agency Settings', 'agency_settings'],
      ['Agency Signup Links', 'agency_signup_links'],
      ['Agency Subscriptions', 'agency_package_subscriptions'],
      ['Archived Agencies', 'archived_agencies'],
      ['Archived Clients', 'archived_clients'],
      ['Billing', 'billing'],
      ['Case Studies', 'case_studies'],
      ['Client Academy', 'client_academy'],
      ['Client Questionnaire', 'client_questionnaire'],
      ['Client Subscriptions', 'client_package_subscriptions'],
      ['Clients', 'clients'],
      ['Content', 'content_settings'],
      ['Contractors', 'contractors'],
      ['Contractor Invites', 'contractors_upload_user'],
      ['Custom Packages', 'custom_packages'],
      ['Documents', 'documents'],
      ['Email Templates', 'email_templates'],
      ['Facebook Ads', 'facebook_ads'],
      ['FAQ', 'faq'],
      ['Funnel Pages', 'funnel_pages'],
      ['Lead Strategy Item', 'lead_strategy_item'],
      ['Lead Strategy', 'lead_strategy'],
      ['Leads', 'leads'],
      ['Manage Admin Academy','manage_admin_academy'],
      ['Manage Labels', 'manage_labels'],
      ['Messages', 'messages'],
      ['Metrics', 'location_map'],
      ['Onboarding Checklists', 'onboarding_checklists'],
      ['Onboarding Procedures', 'onboarding_procedures'],
      ['Packages', 'packages'],
      ['Partner Search', 'partner_search'],
      ['Payment Links', 'payment_links'],
      ['Portfolio', 'portfolio'],
      ['Questionnaire', 'questionnaire'],
      ['Reports', 'reports'],
      ['SMB Signup Links', 'business_signup_links'],
      ['SMB Subscriptions', 'smb_package_subscriptions'],
      ['Social Posts', 'social_posts'],
      ['Third Party Integrations', 'third_party_integrations'],
      ['Value Hooks', 'value_hooks'],
      ['Verified Domains Agencies', 'verified_domains_agencies'],
      ['Agency Demo', 'demo_agency'],
      ['Message Report', 'message_report'],
      ['Outscraper Data', 'outscraper_data'],
      ['Outscraper Bulk Upload', 'outscraper_bulk_upload'],
      ['Outscraper Categories', 'outscraper_categories'],
      ['Welcome Banner', 'welcome_banner'],
      ['Email Sents', 'email_sents'],
      ['Mailgun Subdomains', 'mailgun_subdomains'],
      ['Blacklisted Domains', 'blacklisted_domains'],
      ['Social Media Prompts', 'social_media_prompts']
    ].sort_by(&:first)
  end

  PERMISSION_INFO = [

    {
      name: 'Leads',
      key: 'leads_agency_permission'
    },
    {
      name: 'Plans',
      key: 'packages_agency_permission'
    },
    {
      name: 'Projects',
      key: 'projects_agency_permission'
    },
    {
      name: 'Branding',
      key: 'branding_agency_permission'
    },
    {
      name: 'Badging',
      key: 'badges_agency_permission'
    },
    {
      name: 'Scale Program',
      key: 'scale_program_agency_permission'
    },
    {
      name: 'Affiliate',
      key: 'affiliate_dashboard_agency_permission'
    },
    {
      name: 'Agency Plans',
      key: 'agency_infrastructure_agency_permission'
    },
    {
      name: 'Website',
      key: 'agency_website_agency_permission'
    },
    {
      name: 'Facebook Ads',
      key: 'agency_facebook_ads_agency_permission'
    },
    {
      name: 'Google Ads',
      key: 'agency_google_ads_agency_permission'
    },
    {
      name: 'Scale Coaching',
      key: 'sales_coaching_agency_permission'
    },
    {
      name: 'Support',
      key: 'support_agency_permission'
    }
  ]

  PERMISSION_WHITE_LABELLED = [

    {
      name: 'Grader',
      key: 'grader_reports_agency_permission'
    },
    {
      name: 'ROI Calculator',
      key: 'roi_agency_permission'
    },
    {
      name: 'Niches',
      key: 'industries_agency_permission'
    },
    {
      name: 'Documents',
      key: 'documents_agency_permission'
    },
    {
      name: 'Portfolio',
      key: 'portfolio_agency_permission'
    },
    {
      name: 'FAQ',
      key: 'faqs_agency_permission'
    },
    {
      name: 'Courses',
      key: 'courses_agency_permission'
    }

  ]

  PERMISSION_PAYMENT = [

    {
      name: 'Payments',
      key: 'payment_links_agency_permission'
    }
  ]

  PERMISSION_COMMUNITY = [

    {
      name: 'Community',
      key: 'community_agency_permission'
    }

  ]

  def agency_roles_permission
    roles.pluck(:name)
  end

  def permission_info_collection
    agency_permission_roles.map { |ci| [ci[:name], ci[:key]]}
  end

  def agency_permission_roles

    agency_permission_roles_list = PERMISSION_INFO

    agency_permission_roles_list = agency_permission_roles_list + PERMISSION_WHITE_LABELLED if ownable_agency.white_labeled == true

    agency_permission_roles_list = agency_permission_roles_list + PERMISSION_PAYMENT if ownable_agency.payment_links_enabled == true

    agency_permission_roles_list = agency_permission_roles_list + PERMISSION_COMMUNITY if ownable_agency.has_active_subscription?

    agency_permission_roles_list

  end

  def sync_with_hubspot
    SyncWithHubspotJob.perform_async(id)
  end

  def invitation_status
    return 'Accepted' if invitation_accepted_at

    'Sent'
  end

  def name_with_email
    "#{name} <#{email}>"
  end

  def sync_with_closeio
    SyncWithCloseioJob.perform_async(id)
  end

  def network_profile
    super || create_network_profile
  end
end
