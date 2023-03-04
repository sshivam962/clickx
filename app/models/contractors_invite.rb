class ContractorsInvite < ApplicationRecord
  acts_as_paranoid

  belongs_to :workable_job,
             foreign_key: :shortcode,
             primary_key: :shortcode,
             inverse_of: :contractors_invites,
             optional: true

  validates :first_name, presence: true
  validates :email, uniqueness: true

  delegate :full_title, to: :workable_job, prefix: true, allow_nil: true

  scope :not_emailed, -> { where(mail_status: false) }
  scope :emailed, -> { where(mail_status: true) }

  EMAIL_TEMPLATES = [
    ['Generic Invite (No Personalization)', 'generic_template'],
    ['Current CFN Member Invite (For LinkedIn)', 'member_invite_template'],
    ['Past Job Candidate Invite (Career Portal)', 'old_candidate_template'],
    ['CFN Freshteam Candidates', 'freshteam_candidate_template']
  ]

  def workable?
    workable_id.present?
  end

  def name
    [first_name, last_name].select(&:present?).join(' ')
  end

  def self.workable_sync!(params = {})
    paging = { 'next' => "#{Workable::BASE_URL}/candidates?" }
    while paging.present?
      resp = Workable.candidates(url: paging['next'], params: params)
      resp['candidates']&.each do |c|
        candidate = ContractorsInvite.with_deleted.find_by(email: c['email'])
        candidate ||= ContractorsInvite.with_deleted.find_by(workable_id: c['id'])
        candidate ||= ContractorsInvite.new
        candidate.workable_id = c['id']
        candidate.source = 'workable'
        candidate.first_name = c['name']
        candidate.phone = c['phone']
        candidate.email = c['email']
        candidate.shortcode = c['job']['shortcode']
        candidate.workable_created_at = Time.zone.parse(c['created_at'])
        candidate.workable_updated_at = Time.zone.parse(c['updated_at'])
        candidate.save
      end
      paging = resp['paging']
    end
  end

  def self.fetch_by_encrypted_email encrypted_email
    crypt = ActiveSupport::MessageEncryptor.new(EMAIL_KEY)
    decrypted_email = crypt.decrypt_and_verify(encrypted_email)
    find_by_email(decrypted_email)
  end

  def encrypted_email
    crypt = ActiveSupport::MessageEncryptor.new(EMAIL_KEY)
    crypt.encrypt_and_sign(email)
  end
end
