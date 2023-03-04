class Lead::Strategy < ApplicationRecord
  acts_as_paranoid

  belongs_to :lead
  has_many :strategy_images, inverse_of: :lead_strategy, foreign_key: :lead_strategy_id

  enum status: %i[in_process pending_approval approved]
  delegate :agency, to: :lead

  accepts_nested_attributes_for :strategy_images,
                                reject_if: :all_blank,
                                allow_destroy: true
  CATEGORIES = {
    'Facebook Lead Gen' => 'facebook_leadgen',
    'Facebook Ecommerce' => 'facebook_ecommerce',
    'Google Lead Gen' => 'google_leadgen',
    'Google Ecommerce' => 'google_ecommerce',
    'Google & Facebook Lead Gen' => 'google_facebook_leadgen',
    'Google & Facebook Ecommerce' => 'google_facebook_ecommerce',
    'LinkedIn Lead Gen' => 'linkedin_leadgen',
    'SEO' => 'seo'
  }

  STATIC_CATEGORIES = {
    'Facebook Ads' => 'facebook_ads',
    'Google Ads' => 'google_ads',
    'Linkedin Ads' => 'linkedin_ads',
    'SEO' => 'seo'
  }

  validates :category, presence: true, uniqueness: {scope: :lead}, inclusion: { in: CATEGORIES.keys }

  after_save :send_pending_approval_email, if: :saved_change_to_status?
  before_save :validate_limit, if: :will_save_change_to_deleted_at?

  def self.status_collection
    statuses.keys.unshift('new_leads').push('old_leads')
  end

  def send_approved_email
    return if created_by?('agency_admin')
    return unless approved?

    lead.agency.users.normal.each do |user|
      StrategyMailer.approved(id, user.id).deliver_now
    end
  end

  def created_by?(user_type)
    created_by.eql?(user_type)
  end

  private

  def send_pending_approval_email
    return if created_by?('agency_admin')
    return unless pending_approval?

    StrategyMailer.pending_approval(id).deliver_later
  end

  def validate_limit
    return if agency.this_month_strategies.count < agency.strategy_limit

    self.errors.add(:base, 'This monthly strategy limit exceeded!')
    throw(:abort)
  end

end
