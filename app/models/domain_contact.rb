class DomainContact < ApplicationRecord
  acts_as_paranoid
  belongs_to :direct_lead, counter_cache: true
  belongs_to :sender, -> { with_deleted },
                      class_name: 'User',
                      foreign_key: :sender_id, optional: true
  belongs_to :verifier, -> { with_deleted },
                        class_name: 'User',
                        foreign_key: :verified_by, optional: true
  belongs_to :rejected_by, -> { with_deleted },
                           class_name: 'User',
                           foreign_key: :rejected_by_id, optional: true
  has_many :email_click_events, dependent: :destroy
  has_many :sent_emails, dependent: :destroy

  # mount_uploader :image, ImageUploader
  enum status: %w[added rejected resubmitted]
  enum created_type: { manual: 0, csv: 1, outscraper: 2 }

  validates :email, presence: true

  before_validation do
    self.first_name = first_name.capitalize if first_name.present?
    self.last_name = last_name.capitalize if last_name.present?
  end

  delegate :from_email_name, to: :direct_lead

  def email_sent?
    sent_emails.exists?
  end

  def block_lead
    direct_lead.update(blocked_at: Time.current)
  end

  def full_name
    name.presence || [first_name, last_name].select(&:present?).join(' ')
  end

  def to_email
    if full_name.present?
      "#{full_name}<#{email}>"
    else
      email
    end
  end

  def self.next_office_time
    current_time = DateTime.current
    office_start_time = current_time.beginning_of_day + 7.hours
    office_close_time = office_start_time + 12.hours

    if current_time.sunday?
      current_time.next_day.beginning_of_day + 7.hours
    elsif Date.parse('2022-11-25') == Date.current
      current_time.next_day(3).beginning_of_day + 7.hours
    # elsif current_time.saturday?
    #   current_time.next_day(2).beginning_of_day + 7.hours
    elsif current_time.between?(office_start_time, office_close_time)
      30.seconds.from_now
    elsif current_time < office_start_time
      current_time.beginning_of_day + 7.hours
    else
      current_time.next_day.beginning_of_day + 7.hours
    end + rand(1..300).seconds
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

  def clickx_user_send(user, sent_mail)
    LeadContactMailer.contact_email(sent_mail).deliver_later
    @send_status = true
  rescue Exception
    @send_status = false
  ensure
    update_sent_mail(user, sent_mail) if @send_status
  end

  def verify_and_send(user, sent_mail)
    # LeadContactMailer.contact_email(self).deliver_later
    LeadContactMailer.delay_until(DomainContact.next_office_time)
                     .contact_email(sent_mail)
    # LeadContactMailer.contact_email(self).deliver_now
    @send_status = true
  rescue Exception
    @send_status = false
  ensure
    update_sent_mail(user, sent_mail) if @send_status
  end

  def verify_and_send_now(user, sent_mail)
    LeadContactMailer.contact_email(sent_mail).deliver_now
    @send_status = true
  rescue Exception
    @send_status = false
  ensure
    update_sent_mail(user, sent_mail) if @send_status
  end

  def update_sent_mail(user, sent_mail)
    sent_mail.update_columns(
      sender_id:       user.id,
      verified_at:     Time.current,
      verified_by:     user.id,
      email_queued_at: Time.current
    )
  end

  def next_template
    direct_lead.lead_source.lead_source_email_templates.find_by(
      position: sent_emails.count + 1
    )&.email_template || EmailTemplate.new
  end

end
