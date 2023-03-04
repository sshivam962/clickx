class LeadSource < ApplicationRecord
  acts_as_paranoid

  belongs_to :agency
  has_many :direct_leads, dependent: :destroy
  has_many :contacts, through: :direct_leads, class_name: 'DomainContact'
  has_many :sent_emails, through: :direct_leads
  has_many :lead_source_files, dependent: :destroy
  has_many :cold_email_batches, dependent: :destroy
  has_many :lead_source_email_templates, dependent: :destroy, inverse_of: :lead_source
  has_many :email_templates, -> { order(position: :asc) }, through: :lead_source_email_templates

  accepts_nested_attributes_for :lead_source_files,
                            reject_if: :all_blank,
                            allow_destroy: true
  accepts_nested_attributes_for :lead_source_email_templates, allow_destroy: true, reject_if: ->(attributes) { attributes['email_template_id'].blank? }

  validates :name, presence: true

  scope :order_by_name, -> { order(name: :asc) }
  scope :order_by_created, -> { order(created_at: :desc) }
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }

end
