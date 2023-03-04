class DirectLead < ApplicationRecord
  acts_as_paranoid
  belongs_to :lead_source

  # belongs_to :contacted_by, class_name: 'User', optional: true
  # belongs_to :skipped_by, class_name: 'User', optional: true

  has_many :contacts, class_name: 'DomainContact', dependent: :destroy, inverse_of: :direct_lead
  has_many :sent_emails, through: :contacts

  mount_uploader :screenshot_image, ImageUploader

  validates :name, presence: true
  validates :base_domain, presence: true
  validates :base_domain, uniqueness: true, if: -> { agency_level_uniqueness }
  scope :not_viewing, (lambda do
    where.not(viewed_at: (Time.current - 10.minutes)..Time.current)
    .or(where(viewed_at: nil))
  end)
  scope :emailed, -> { where('sent_emails.id IS NOT NULL') }
  scope :order_by_last_sent_email, -> { order('sent_emails.created_at DESC') }

  scope :with_enabled_service, (lambda do
    joins(:lead_source)
    .where(lead_sources: { enabled: true })
  end)

  scope :with_contacts, (lambda do
    where.not(domain_contacts: { id: nil })
  end)

  scope :without_contacts, (lambda do
    where(domain_contacts: { id: nil })
  end)

  scope :with_lead_source, (lambda do |lead_source_id|
    lead_source_id.present? ? where(lead_source_id: lead_source_id) : all
  end)

  scope :viewed_order, -> { order('viewed_at IS NOT NULL, viewed_at ASC') }

  scope :not_converted, -> { where(converted: false) }

  scope :not_rejected, -> { where(rejected_at: nil) }

  def lead_gen
    lead_source
  end

  def agency_level_uniqueness
    base_domain = self.base_domain
    agency = lead_source.agency
    dup_record = []
    agency.lead_sources.each do |lead_source|
      dup_record << lead_source.direct_leads.where(base_domain: base_domain).empty?
    end
    if dup_record.include? false
      true
    else
      false
    end
  end

  def from_email_name
    lead_source.from_email_name.presence
  end

  def blocked?
    blocked_at.present?
  end

  def rejected?
    rejected_at.present?
  end
end
