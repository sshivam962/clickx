# frozen_string_literal: true

class ProcessAutopilotEmailJob
  include Sidekiq::Worker

  def perform(lead_source_id, user_id, direct_lead_ids, report_id = nil)
    begin
      @lead_source = LeadSource.find_by_id(lead_source_id)
      @current_user = User.find_by_id(user_id)
      @current_agency = @lead_source.agency
      @batch_size = @lead_source.batch_size || 10
      @report_id = ColdEmailAutomateSedningReport.find_by_id(report_id) if report_id.present?
      @record_count = 0
      @direct_lead_ids = direct_lead_ids
      return if @lead_source.blank?
      process_autopilot
      @cold_email_batch.update(record_count: @record_count, status: "completed")
    rescue => e
      Rails.logger.info "e.message"
      @cold_email_batch.update(record_count: @record_count, status: "failed") if @cold_email_batch.present?
    end
  end

  def process_autopilot
    @cold_email_batch = create_new_cold_email_batch
    DomainContact.where("email_opened_at is null and email_sent_at is null and direct_lead_id in (?)", @direct_lead_ids).find_in_batches(batch_size: @batch_size) do |batch_domain_contacts|
      batch_domain_contacts.each do |domain_contact|
        if @record_count < @batch_size &&
          @current_agency.email_leads_count_limit >=  @current_agency.send_email_leads_count
          verify_contact_email(domain_contact)
        end
      end
    end
  end

  def create_new_cold_email_batch
    @lead_source.cold_email_batches.new(name: "Batch_#{Time.now.strftime("%Y_%m_%d")}", batch_size: @batch_size)
  end

  def validate_email_domain_send_leads(contact)
    if @current_agency.cold_email_sub_domain.blank?
      return { valid: false, message: "To send emails, please add a sub domain." }
    end

    # cold_domain_name = "@"+@current_agency.cold_email_sub_domain.to_s.downcase

    # if contact.from_email_name.to_s.downcase.include?(cold_domain_name)
    #   [true, "Email address used does not match verified domain."]
    # else
    #   [false]
    # end
  end

  def validate_contact_details(domain_contact)
    base_domain = domain_contact&.direct_lead&.base_domain.to_s.downcase
    email_to = domain_contact.email.to_s.downcase.to_s.downcase
    return true if base_domain.blank? || email_to.blank?
    email_to.include?(base_domain) ? false : true
  end

  def verify_contact_email(domain_contact)
    return if validate_contact_details(domain_contact)
    email_validation = validate_email_domain_send_leads(domain_contact)
    return if !email_validation[:valid]
    # email_status = verify_email(domain_contact)
    # image_status = domain_contact&.direct_lead.screenshot_image.present? || WebSiteScreenshotService.verify_image(domain_contact&.direct_lead)

    mail = domain_contact.sent_emails.create(
      content: scan_email_body_and_header(domain_contact)
    )

    email_send_status = domain_contact.verify_and_send_now(@current_user, mail)

    if email_send_status
      if @record_count == 0
        @cold_email_batch.save
        @report_id.update(cold_email_batch_id: @cold_email_batch.id) if @report_id.present?
      end
      @record_count = @record_count + 1
      domain_contact.update(
        cold_email_batch_id: @cold_email_batch.id
      )
      @current_agency.send_email_leads_count = @current_agency.send_email_leads_count.to_i + 1
      @current_agency.save
      @lead_source.send_email_leads_count = @lead_source.send_email_leads_count + 1
      @lead_source.save
    end
  end

  def scan_email_body_and_header(domain_contact)
    @direct_lead = domain_contact.direct_lead
    wordpress =
      @direct_lead.wordpress? ? @lead_source.word_press : ''
    @liquid_template = Liquid::Template.parse(@lead_source.email_template)
    @liquid_template.render(
      'first_name' => domain_contact.first_name,
      'domain' => @direct_lead.base_domain,
      'company_name' => @direct_lead.name,
      'instagram' => domain_contact.instagram,
      'screenshot' => screenshot(@direct_lead.screenshot_image.url),
      'wordpress' => wordpress
    )
  end

  def screenshot(root_url)
    return '' if root_url.blank?
    "<img src='#{root_url}' width='400' height='350' alt='' />"
  end

  def verify_email(domain_contact)
    response =
      Faraday.get("https://api.app.outscraper.com/validators/email",
                  {query: domain_contact.email, async: "false"},
                  {"X-API-KEY": ENV['OUTSCRAPER_API_KEY']})
    return false if response.blank?
    JSON.parse(response.body)['data'][0]['status'] == "RECEIVING"
  end
end
