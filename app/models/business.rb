# frozen_string_literal: true

class Business < ApplicationRecord
  acts_as_paranoid
  obfuscatable
  include UniqueId
  include Majestic

  extend FriendlyId

  # before_destroy has to be defiend before any associations
  before_destroy do
    deleted_keywords.delete_all
    KeywordRanking.joins(:keyword).where(keywords: { business_id: id }).delete_all
  end

  acts_as_tagger
  acts_as_taggable_on :labels

  friendly_id :slug_candidates, use: %i[slugged history]

  belongs_to :agency
  belongs_to :last_logged_in_user, class_name: 'User', foreign_key: :last_logged_in_user_id, optional: true

  has_many :activities, dependent: :delete_all
  has_many :ad_reports, dependent: :delete_all
  has_many :backlink_histories, dependent: :delete_all
  has_many :competitions, dependent: :delete_all
  has_many :content_orders, dependent: :delete_all
  has_many :contents, dependent: :delete_all
  has_many :email_preferences, as: :ownable, dependent: :delete_all

  has_many :keyword_tags, dependent: :delete_all
  has_many :payment_details, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :reviews, through: :locations

  has_many :admin_users, class_name: 'User', as: :ownable
  has_many :businesses_users
  has_many :users, through: :businesses_users
  has_many :preview_user, -> { where(preview_user: true) }, through: :businesses_users, source: :user
  has_many :preview_users, -> { merge(User.preview) }, through: :businesses_users, source: :user
  has_many :normal_users, -> { merge(User.normal) }, through: :businesses_users, source: :user

  has_many :deleted_keywords, -> { only_deleted }, source: :keyword, class_name: 'Keyword'
  has_many :keywords, dependent: :delete_all

  has_many :search_terms, dependent: :delete_all

  has_many :subscription_accounts, class_name: 'Subscription::Account', dependent: :destroy, as: :accountable
  has_many :tasks, dependent: :delete_all
  has_many :tokens, dependent: :delete_all
  has_many :custom_urls, dependent: :destroy

  has_one :backlink_datum, dependent: :destroy
  has_one :content_order_default, dependent: :destroy
  has_one :fb_ad_account, dependent: :destroy
  has_one :grader_report, as: :reportable, dependent: :destroy
  has_one :intelligence_cache, dependent: :destroy
  has_one :leo_api_datum, dependent: :destroy
  has_one :marketing_performance_goal, dependent: :destroy
  has_many :keyword_tags, dependent: :destroy
  has_many :onboarding_procedures, dependent: :destroy
  has_one :integration_detail

  has_one :questionnaire, dependent: :destroy
  has_one :reminder_email, dependent: :destroy
  has_one :subscription, class_name: 'SubscriptionInfo'
  has_one :lead

  belongs_to :custom_plan, -> { only_private }, class_name: 'Subscription::Plan', foreign_key: :custom_plan_id, optional: true

  has_many :fb_ad_reports, dependent: :destroy
  has_many :google_ad_reports, dependent: :destroy

  has_many :package_subscriptions, dependent: :destroy
  has_many :active_package_subscriptions,
           -> { merge(PackageSubscription.active) },
           class_name: 'PackageSubscription'
  has_many :custom_packages
  has_many :client_questionnaires, foreign_key: :client_id,
           class_name: 'Inquiry::ClientQuestionnaire'

  has_one :billing_address, as: :billing_addressable,
    foreign_type: :addressable_type, foreign_key: :addressable_id,
    class_name: 'BillingAddress', dependent: :destroy

  has_one :agreement, as: :agreementable, class_name: 'Agreement',
          dependent: :destroy

  has_many :payment_links, as: :resource, dependent: :destroy
  has_many :semrush_keywords, dependent: :delete_all

  validates :name, :agency, presence: true
  validates :domain,
            uniqueness: { allow_blank: true, case_sensitive: false,
                          scope: %i[deleted_at target_city] },
            unless: -> { agency&.allow_client_duplication }
  validates :target_city,
            uniqueness: { allow_blank: true, case_sensitive: false,
                          scope: %i[deleted_at domain],
                          message: lambda { |object, _data|
                            "(#{object.target_city}) has already been taken for the domain #{object.domain}"
                          } },
            unless: -> { agency&.allow_client_duplication }
  validates :domain, url: true
  validates :trial_expiry_date, presence: true, if: -> { trial_service }

  before_create :assign_unique_id,
                :check_limit_validations

  after_create :create_leo_api_datum,
               :create_reminder_email,
               :create_clickx_user
               # :build_cache_for_intelligence

  before_validation :add_protocol_to_domain

  before_save :update_pages_crawled, :add_free_label, :update_site_audit_service
  before_save :update_backlinks_service
  before_save :update_trial_label, if: :will_save_change_to_trial_service?
  before_save :update_uptime_monitor,
              if: -> { Rails.env.production? &&
                       (will_save_change_to_managed_seo_service? ||
                       will_save_change_to_managed_ppc_service?) }

  after_save :clear_business_cache
  after_save :update_backlinks, if: -> { saved_change_to_domain? && Rails.env.production? } # TODO: move to background

  after_update :reorder_keywords, if: :keyword_limit_changed?

  before_destroy :delete_uptime_monitor,
                 if: -> { Rails.env.production? && monitor_id.present? }
  after_restore -> { perform_mailchimp_job('Add') }
  after_destroy -> { perform_mailchimp_job('Remove') }

  # We are not destroying the elements like before thus
  # no need to restore the elements.
  #
  # after_restore do
  #   run_callbacks :create
  # end

  before_save do
    target_city.downcase!
    domain.downcase!

    CreateActivities.perform_later(attributes_changed, current_user.id, id) if current_user.present? && attributes_changed.positive?
  rescue StandardError
    nil
  end

  def attributes_changed
    changes_made = changes.except(
      'id', 'user_id', 'created_at', 'updated_at',
      'agency_id', 'unique_id', 'labels', 'deleted_at',
      'logo', 'slug', 'label_list', 'last_logged_in'
    )
    if changes_made['trial_expiry_date'].present?
      changes_made['trial_expiry_date'] =
        changes_made['trial_expiry_date'].map(&:to_s)
    end
    changes_made
  end

  default_scope { where(dummy: false) }
  scope :with_dummy, -> { unscope(where: :dummy) }
  scope :dummy, -> { unscope(where: :dummy).where(dummy: true) }
  scope :unarchived, -> { where(deleted_at: nil) }
  scope :managing_seo_service, -> { where managed_seo_service: true }
  scope :managing_ppc_service, -> { where managed_ppc_service: true }
  scope :demo, -> { tagged_with('Demo') }
  scope :trial, -> { tagged_with('Trial') }
  scope :free, -> { tagged_with('Free') }
  scope :not_free, -> { tagged_with('Free', exclude: true) }
  scope :prospect, -> { tagged_with('Prospect') }
  software_tags = ['Software', 'Tier I', 'Tier II', 'Tier III'].freeze
  scope :software, -> { tagged_with(software_tags, any: true) }
  scope :service, (lambda do
    where('managed_seo_service OR managed_ppc_service = true')
  end)
  scope :non_service, (lambda do
    where(managed_seo_service: false, managed_ppc_service: false)
  end)
  scope :analytics_connected, -> { where.not(google_analytics_id: EMPTY) }
  scope :search_console_connected, -> { where.not(site_url: EMPTY) }
  scope :search_adwords_enabled, -> { where.not(adword_client_id: EMPTY) }
  scope :facebook_ads_enabled, -> { where.not(fb_ad_account_id: nil) }
  scope :search_by_name, ->(query) { where("lower(name) ILIKE '%#{query.downcase}%'") }
  scope :active_last_month, -> { where(deleted_at: [Time.zone.today.ago(1.month).beginning_of_month..Time.zone.today.ago(1.month).end_of_month, nil]) }

  scope :with_keyword_ranking, -> { where(keyword_ranking_service: true) }
  scope :without_semrush, -> { where(semrush_project_id: nil) }

  alias_attribute :adword_budget, :ppc_budget

  delegate :support_email, :from_email, :clickx?,
           :support_members, :yext_creds,
           to: :agency, allow_nil: true
  delegate :name, :logo, :square_logo, :email_logo, :address, to: :agency, prefix: true, allow_nil: true
  delegate :white_labeled?, to: :agency

  attr_accessor :current_user

  accepts_nested_attributes_for :users, :locations, reject_if: :all_blank

  def users_with_email_preference(feature, key)
    if EmailPreference.default?(feature, key)
      users
        .normal
        .where
        .not(id: users.with_user_email_preference(feature, key, false)
        .pluck(:id))
        .union(
          agency
          .users
          .normal
          .where.not(id: agency.users.with_agency_admin_email_preference(feature, key, false))
        )

    else
      users.with_user_email_preference(feature, key, true).union(
        agency.users.with_agency_admin_email_preference(feature, key, true)
      )
    end
  end

  def check_limit_validations
    check_keyword_limit
    check_competitors_limit
  end

  def check_keyword_limit
    if agency.remaining_keywords < keyword_limit
      self.keyword_limit = agency.remaining_keywords
    elsif agency.remaining_keywords.negative?
      self.keyword_limit = 0
    end
  end

  def check_competitors_limit
    if agency.remaining_competitors < competitors_limit
      self.competitors_limit = agency.remaining_competitors
    elsif agency.remaining_competitors.negative?
      self.competitors_limit = 0
    end
  end

  def slug_candidates
    if new_record?
      [
        :name,
        [:name, rand(10_000..(Business.where(name: name).count * 10_000)).to_s]
      ]
    else
      [
        :name,
        %i[name id]
      ]
    end
  end

  def reorder_keywords
    Keyword.check_for_limit_changes(id)
  end

  def perform_mailchimp_job(action)
    "Mailchimp#{action}BusinessJob".constantize.perform_later(self) if Rails.env.production?
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank? || saved_change_to_name?
  end

  def grader_report
    super || create_grader_report
  end

  def as_json(options = {})
    super.merge(top_reviews_url: top_reviews_url)
    if options[:index]
      data = super(options.merge(except: %i[created_at labels],
                                 methods: [:label_list]))
      data = data.merge(system_user: preview_users.first,
                        agency: agency&.name)
    elsif options[:popup_list]
      data = super(options.merge(except: %i[created_at labels],
                                 methods: [:expired_name]))
      data
    elsif options[:all_info]
      methods =
        %i[support_email logo remaining_days label_list
           customer_id is_clickx active_subscription trialing_subscription
           active_subscription_period trialing_subscription_period
           onboarding_procedures custom_plan]

      data = super(options.merge(except: %i[created_at labels],
                                 methods: methods))
      data = data.merge(users: users_data, locations: locations_data)
    elsif options[:super]
      data = super
    else
      data = super(options.merge(except: %i[created_at labels], methods: %i[is_clickx support_members onboarding_procedures]))
    end
    data
  end

  def labels_list
    labels.collect(&:name).sort
  end

  def is_clickx # rubocop:disable Naming/PredicateName
    clickx?
  end

  def branded?
    clickx?
  end

  def users_data
    users.as_json
  end

  def locations_data
    locations.includes(%i[social_links business]).as_json
  end

  # after creating company we create a system user which is preview user
  # who can sign in & check account before actual users are invited
  def create_clickx_user
    clickx_user = users.create(
      first_name: "#{name} #{app_name}",
      last_name: 'System User',
      preview_user: true,
      role: User::CompanyAdmin,
      invitation_sent_at: Time.current,
      invitation_accepted_at: Time.current,
      password: Devise.friendly_token.first(8),
      email: "#{id}.#{unique_id}@#{app_name.parameterize}.io"
    )
    clickx_user
  end

  def app_name
    agency.white_label_name.presence || agency.name.presence || 'Clickx'
  end

  def update_pages_crawled
    self.total_pages_crawled = 100 if trial_service
  end

  def add_free_label
    if free_service_changed?
      label_list.add('Free') if free_service
      label_list.remove('Free') unless free_service
    end
  end

  def backlink_datum
    super || build_backlink_datum
  end

  def update_backlinks
    return unless backlink_service
    Thread.new do
      backlink_summary = get_backlink_summary(domain)
      backlinks = get_backlinks(domain)
      top_pages = Majestic.get_top_pages(domain)
      anchor_text_chart = get_anchor_text_chart_data(domain)
      word_cloud = get_word_cloud_data(domain)
      ref_domain = get_ref_domain(domain)
      anchor_text = get_anchor_text(domain)
      topics = get_topics(domain)
      build_backlink_datum unless backlink_datum
      backlink_datum.update(
        summary: backlink_summary,
        backlinks: backlinks,
        anchor_text: anchor_text,
        topics: topics,
        pages: top_pages,
        ref_domains: ref_domain,
        anchor_chart_data: anchor_text_chart,
        anchor_word_cloud: word_cloud
      )
    end
  end

  def remaining_days
    (trial_expiry_date.to_date - Date.current).round if trial_service && trial_expiry_date.present?
  end

  # only for pop up we need to show name with expired as suffix
  def expired_name
    trial_expired? ? "#{name} (Expired)" : name
  end

  def trial_expired?
    trial_service && remaining_days.to_i <= 0 ? true : false
  end

  def top_reviews_url
    Rails.application.routes.url_helpers.business_reviews_url(obfuscated_id, host: ROOT_URL)
  end

  def self.all_businesses_cached
    Rails.cache.fetch("businesses/#{Business.maximum(:updated_at)}-#{Business.count}/") do
      Business.includes([:agency, :users, locations: [:business]]).to_json
    end
  end

  def clear_business_cache
    Rails.cache.delete("businesses/#{Business.maximum(:updated_at)}-#{Business.count}/")
  end

  def web_url
    begin
      unless domain[/\Ahttp:\/\//] || domain[/\Ahttps:\/\//]
        @domain = "http://#{domain}" if domain.present?
      end
    rescue StandardError
      nil
    end
    @domain || domain
  end

  # Integrations

  def build_cache_for_intelligence
    return if Rails.env.test?
    return if dummy?
    Businesses::Intelligence.new(self).cache
  end

  def free_service?
    label_list.include?('Free')
  end

  def potential_competitors
    Rails.cache.fetch("#{cache_key}/potential_competitions", expires_in: 30.days) do
      existing_domains = competitions.pluck(:name)
      {
        organic: Semrush.competitors_organic(host)
                        .reject { |competitor| existing_domains.include?(competitor[:domain]) },
        paid: Semrush.competitors_adwords(host)
                     .reject { |competitor| existing_domains.include?(competitor[:domain]) }
      }
    end
  end

  def host
    @_host ||= URI.parse(domain).host.to_s
  end

  def backlinks_to_competitors
    subquery = competitions
               .select(:id)
               .select("COUNT
                       (SUBSTRING
                         (
                           (each_link -> 'SourceURL')::text
                           FROM '[\\w]*://(?:[^/:]*:[^/@]*@)?(?:[^/:.]*\.)\\w*\.[\\w\/]*'
                         )
                       ) as count_each_link_sourceurl_text
                       ")
               .select("SUBSTRING (
                         (each_link -> 'SourceURL')::text
                         FROM '[\\w]*://(?:[^/:]*:[^/@]*@)?(?:[^/:.]*\.)\\w*\.[\\w\/]*' )
                       AS each_link_sourceurl_text")
               .from('competitions cross join json_array_elements(backlinks) each_link')
               .group('id, each_link_sourceurl_text')
               .order('count_each_link_sourceurl_text DESC ')

    Competition.unscoped
               .select('COUNT(id),each_link_sourceurl_text as domain')
               .where('each_link_sourceurl_text IS NOT NULL')
               .from(subquery)
               .group('each_link_sourceurl_text')
               .order('COUNT(id) desc')
               .limit(10)
  end

  def frequent_organic_keywords_among_competitors
    subquery = competitions
               .select("REPLACE((each_keyword -> 'keyword')::text, '\"', E'')  as keyword")
               .joins('cross join json_array_elements (keywords_organic) each_keyword')
               .group(:keyword, :id)
    Competition.unscoped
               .select('keyword,COUNT(keyword) as keyword_count')
               .from(subquery)
               .group('keyword')
               .order('keyword_count DESC')
               .where('keyword NOT IN (?)', keywords.pluck(:name))
               .limit(20)
  end

  def frequent_paid_keywords_among_competitors
    subquery = competitions
               .select("REPLACE((each_keyword -> 'keyword')::text, '\"', E'')  as keyword")
               .joins('cross join json_array_elements (keywords_adwords) each_keyword')
               .group(:keyword, :id)
    Competition.unscoped
               .select('keyword,COUNT(keyword) as keyword_count')
               .from(subquery)
               .group('keyword')
               .order('keyword_count DESC')
               .where('keyword NOT IN (?)', keywords.pluck(:name))
               .limit(20)
  end

  def potential_keywords
    Rails.cache.fetch("#{cache_key}/potential_keywords", expires_in: 3.days) do
      {
        organic: frequent_organic_keywords_among_competitors,
        paid: frequent_paid_keywords_among_competitors
      }
    end
  end

  def intelligence_enabled?
    managed_service?
  end

  def managed_service?
    managed_seo_service || managed_ppc_service
  end

  def perfomence_report(*args)
    Businesses::PerfomenceReport.new(id, *args).all
  end

  def koala
    Koala::Facebook::API.new(fb_access_token) if fb_access_token
  end

  def koala_page(page_id)
    access_token = koala.get_page_access_token(page_id)
    Koala::Facebook::API.new(access_token)
  end

  def facebook_pages
    return nil unless fb_access_token
    koala.get_object('me/accounts')
  end

  def google_analytics_service?
    google_analytics_id.present?
  end

  def search_console_service?
    site_url.present?
  end

  def adword_service?
    adword_client_id.present?
  end

  def google_ads_service?
    google_ads_customer_client_id.present? &&
      google_ads_login_customer_id.present?
  end

  def fb_ad_service?
    fb_ad_account.present?
  end

  def active_subscription
    if free_service?
      Subscription::Account.new(plan_name: 'Free')
    else
      subscription_accounts.active.first
    end
  end

  def active_subscription_period
    if active_subscription.present?
      {
        start_date: active_subscription.current_period_start
                                       &.strftime("%d %b %Y"),
        end_date: active_subscription.current_period_end
                                     &.strftime("%d %b %Y")
      }
    end
  end

  def trialing_subscription
    subscription_accounts.trialing.first
  end

  def trialing_subscription_period
    if trialing_subscription.present?
      {
        trial_end: trialing_subscription.trial_end
                                        .strftime("%d %b %Y")
      }
    end
  end

  def stripe_customer
    Stripe::Customer.retrieve(customer_id) if customer_id
  rescue Stripe::InvalidRequestError
    nil
  end

  def remove_free_label
    tag_list_on(:label).remove('Free')
    update_attributes(free_service: false)
  end

  def domain_host
    Addressable::URI.parse(domain).host
  rescue StandardError
    nil
  end

  def update_uptime_monitor
    UpdateUptimeMonitorJob.perform_later(self)
  end

  def delete_uptime_monitor
    DeleteUptimeMonitorJob.perform_later(monitor_id)
  end

  def agreement_signed?
    agreement&.signed?
  end

  def questionnaires_with_links
    fetch_client_questionnaires.map do |cq|
      {
        id: cq.id,
        link: cq.link,
        category: cq.category,
        answered: cq.answers.present?
      }
    end
  end

  def fetch_client_questionnaires
    Inquiry::Questionnaire.includes(:questions).find_each do |questionnaire|
      next if questionnaire.questions.blank?

      client_questionnaires.find_or_create_by(questionnaire: questionnaire)
    end
    client_questionnaires.includes(:answers, :questionnaire)
  end

  def questionnaires_by_categories categories
    questionnaires =
      Inquiry::Questionnaire.includes(:questions).where(category: categories)
    client_qs = []
    questionnaires.find_each do |questionnaire|
      next if questionnaire.questions.blank?

      client_qs.push(
        client_questionnaires.find_or_create_by(questionnaire: questionnaire)
      )
    end
    client_qs.compact.map do |cq|
      {
        id: cq.id,
        link: cq.link,
        category: cq.category,
        answered: cq.answers.present?
      }
    end
  end

  def initials
    name.split(' ').first.first.capitalize +
      name.split(' ').last.first.capitalize
  end

  def rank_tracking_url
    [
      semrush_project_url, tracking_page_path.to_s
    ].select(&:present?).join('/').gsub('//', '/')
  end

  private

  def add_protocol_to_domain
    return if domain.blank?
    self.domain = domain.downcase.strip
    return if domain[/^http:\/\//] || domain[/^https:\/\//]
    self.domain = if domain.match?(/www\./)
                    "http://#{domain}"
                  else
                    "http://www.#{domain}"
                  end
  end

  def update_site_audit_service
    self.site_audit_service = true if seo_service
  end

  def update_backlinks_service
    self.backlink_service = true if managed_seo_service
  end

  def update_trial_label
    trial_service ? label_list.add('Trial') : label_list.remove('Trial')
  end

  def self.birch_homes
    Business.find_by(name: 'A Birch Homes')
  end
end
