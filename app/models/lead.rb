class Lead < ApplicationRecord
  acts_as_paranoid
  obfuscatable

  belongs_to :agency
  has_many :lead_strategies, class_name: 'Lead::Strategy', dependent: :destroy
  has_many :payment_links, as: :resource, dependent: :destroy

  #validates :first_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :agency_id }
  # validates :company, presence: true
  # validates :call_notes, presence: true

  before_save :validate_domain
  before_save :validate_email

  scope :convertable, -> { where.not(domain: EMPTY, status: 'customer') }

  STATUSES = [
    {
      name: 'Open',
      value: 'open'
    },
    {
      name: 'Connect Call',
      value: 'connect_call'
    },
    {
      name: 'Discovery Meeting',
      value: 'discovery_meeting'
    },
    {
      name: 'Proposal',
      value: 'proposal'
    },
    {
      name: 'Closed Won',
      value: 'closed_won'
    },
    {
      name: 'Closed Lost',
      value: 'closed_lost'
    },
    {
      name: 'Customer',
      value: 'customer'
    },
  ]

  enum status: STATUSES.map{ |s| s[:value] }

  CAMPAIGN_INFO = [
    {
      name: 'Facebook Ads',
      key: 'facebook_ads'
    },
    {
      name: 'SEO Services',
      key: 'seo_services'
    },
    {
      name: 'Google Ads',
      key: 'google_ads'
    },
    {
      name: 'Landing Pages',
      key: 'landing_pages'
    },
    {
      name: 'Local SEO',
      key: 'local_seo'
    },
    {
      name: 'Funnel',
      key: 'funnel'
    },
    {
      name: 'Social Media Management',
      key: 'social_media_management'
    },
    {
      name: 'Digital PR',
      key: 'digital_pr'
    },
    {
      name: 'A La Carte Service(s)',
      key: 'ala_carte_services'
    }
  ]

  NEXT_STEPS = [
    {
      name: 'Campaign Recommendations',
      key: 'campaign_recommendations',
      disabled: false
    },
    {
      name: 'Account / Campaign Audit',
      key: 'account_campaign_audit',
      disabled: false
    },
    {
      name: 'Paid Audit',
      key: 'paid_audit',
      disabled: true
    }
  ]

  AUDIT_REQUESTS = ['Yes', 'No']

  def full_name
    [first_name, last_name].join(' ')
  end

  def name
    full_name
  end

  def self.status_collection
    STATUSES.map{|s| [s[:name], s[:value]]}
  end

  def self.csv_default_attributes
    %w[first_name last_name email company phone domain]
  end

  def self.to_csv(attributes = nil)

    attributes ||= csv_default_attributes
    CSV.generate(headers: true) do |csv_data|
      csv_data << attributes.map(&:titleize)
      self.order(created_at: :desc).each do |lead|
        csv_row = lead.attributes.values_at(*attributes)
        csv_data << csv_row
      end
    end
  end

  def convert_business
    business = agency.businesses.create(name: full_name, domain: domain)
    self.update(business_id: business.id, status: 'customer')
    business
  end

  def initials
    [first_name&.first, last_name&.first].join.upcase
  end

  private

  def validate_domain
    return if domain.blank?

    agency_domain = ApplicationController.helpers.without_scheme(agency.domain)
    lead_domain = ApplicationController.helpers.without_scheme(domain)
    return unless agency_domain.eql?(lead_domain)

    errors.add :base, 'You are not allowed to add your Agency as a Lead'
    throw(:abort)
  end

  def validate_email
    return if email.blank?
    return unless agency.users.exists?(email: email)

    errors.add :base, 'You are not allowed to add your Agency as a Lead'
    throw(:abort)
  end
end
