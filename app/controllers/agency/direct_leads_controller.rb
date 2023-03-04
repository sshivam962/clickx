class Agency::DirectLeadsController < Agency::BaseController
  before_action :set_direct_lead,
                only: %i[
                  preview_mail draft_mail
                  list_contacts create_contact new_contact
                  edit update destroy edit_contact update_contact
                  delete_contact contacts change_lead_source convert reject create_intro
                ]
  before_action :set_contact,
    only: %i[edit_contact update_contact delete_contact]

  before_action :set_lead_source_by_domain, only: :create_from_clickx
  before_action :validate_required_fields, only: :draft_mail
  before_action :set_lead_source, only: :change_lead_source

  def index
  end

  def edit; end

  def update
    root_and_base_urls(params[:url]) or return
    @direct_lead.update(
      lead_params.merge(@url_params)
    )

    remove_cloudinary_image(@direct_lead) if @direct_lead.screenshot_image.present?
    ProceessScreenshotAndWordpressJob.perform_async(@direct_lead.id) if @direct_lead.present?
    @message ||= 'Updated succesfully'
  end

  def destroy
    contacts_count = @direct_lead.contacts.count
    lead_source = @direct_lead.lead_source
    lead_source.total_email_leads_count = lead_source.total_email_leads_count - contacts_count
    lead_source.save
    remove_cloudinary_image(@direct_lead) if @direct_lead.screenshot_image.present?
    @direct_lead.destroy
  end

  def remove_cloudinary_image(lead)
    Cloudinary::Uploader.destroy(lead.screenshot_image.file.public_id, {invalidate: true})
    lead.remove_screenshot_image!
    lead.save
  end

  def create
    @lead_source = LeadSource.find(lead_params["lead_source_id"])
    root_and_base_urls(params[:url]) or return
    @direct_lead = DirectLead.create(
      lead_params.merge(@url_params)
    )
    ProceessScreenshotAndWordpressJob.perform_async(@direct_lead.id) if @direct_lead.present?
    @direct_leads = @lead_source.direct_leads.paginate(page: params[:page], per_page: 10)
    @message = if @direct_lead.persisted?
                 'Direct Lead created successfully'
               else
                 @direct_lead.errors.full_messages.to_sentence
               end

  end

  def direct_lead
    @lead_source =
      if params[:lead_source_id].present?
        current_agency.lead_sources.enabled.find_by(id: params[:lead_source_id])
      else
        current_agency.lead_sources.enabled.order_by_name.first
      end
    return if @lead_source.blank?

    @remain_email_count =
      @lead_source.total_email_leads_count - @lead_source.send_email_leads_count

    @direct_lead =
      if params[:direct_lead_id].present?
        DirectLead.find(params[:direct_lead_id])
      else
        templates_count = @lead_source.email_templates.count

        query = <<~SQL
          MAX(domain_contacts.sent_emails_count) = ? AND
          MAX(sent_emails.email_sent_at) < ?
        SQL

        templates_count.downto(2) do |n|
          @lead ||=
            DirectLead.with_lead_source(@lead_source.id)
                      .not_viewing
                      .not_converted
                      .not_rejected
                      .joins(contacts: :sent_emails)
                      .group('direct_leads.id')
                      .having(query, (n-1), 1.week.ago)
                      .take
        end if templates_count > 1

        @lead ||=
          DirectLead.with_lead_source(@lead_source.id)
                    .not_viewing
                    .not_converted
                    .not_rejected
                    .joins(:contacts)
                    .group('direct_leads.id')
                    .having('MAX(domain_contacts.sent_emails_count) = 0')
                    .take

        @lead
      end

    return if @direct_lead.blank?

    @direct_lead.update_column(:viewed_at, Time.current)
    @contacts =
      @direct_lead.contacts.order(:first_name).select do |contact|
        !BlacklistedDomain.exists?(name: Mail::Address.new(contact.email).domain)
      end

    @contact = @contacts.first

    set_liquid_template(@contact)
  end

  def next_contact
    @contact = DomainContact.find(params[:contact_id])
    @direct_lead = @contact.direct_lead
    @lead_source = @direct_lead.lead_source
    set_liquid_template(@contact)
  end

  def fetch_contact
    @contact = @direct_lead.contacts.order(:first_name)
    @contact = @contacts.find(params[:contact_id])
    set_liquid_template(@contact)
  end

  def preview_mail
    @lead_source = @direct_lead&.lead_source
    @domain_contact = @direct_lead.contacts.find_by_email(params[:email])

    wordpress_content = if @domain_contact && @direct_lead.wordpress?
      @domain_contact.next_template.wordpress_site_custom_content
    else
      ''
    end

    @liquid_template = Liquid::Template.parse(params[:body])
    @template = @liquid_template.render(
      'first_name' => params[:first_name],
      'domain' => @direct_lead.base_domain,
      'company_name' => @direct_lead.name,
      'variable_1' => params[:variable_1],
      'variable_2' => params[:variable_2],
      'variable_3' => params[:variable_3],
      'prompt_1' => params[:prompt_1],
      'prompt_2' => params[:prompt_2],
      'prompt_3' => params[:prompt_3],
      'instagram' => params[:instagram],
      'city' => params[:city],
      'intro' => params[:intro],
      'tomorrow' => EmailLeadDynamicVariableService.new.next_two_working_days,
      'wordpress' => wordpress_content
    )
    subject = Liquid::Template.parse(@lead_source.subject).render(
      'first_name' => params[:first_name],
      'domain' => @direct_lead.base_domain,
      'company_name' => @direct_lead.name,
      'lead_source_name' => @direct_lead.lead_source.name
    )
    render json: {
      template: @template,
      subject: subject
    }
  end

  def create_intro
    @lead_source = @direct_lead&.lead_source

    @gpt_prompt = ''
    if current_agency.name.present?
      agency_name = current_agency.name
      @gpt_prompt << "My company name is #{agency_name}, "
    end

    if current_agency.weburl.present?
      agency_weburl = current_agency.weburl
      @gpt_prompt << "Our website address is #{agency_weburl}, "
    end
    if current_agency.address.present?
      agency_address = current_agency.address
      @gpt_prompt << "My physical address is #{agency_address}, "
    end
    if current_agency.agency_profile.preferred_niche.present?
      agency_preferred_niche = current_agency.agency_profile.preferred_niche
      @gpt_prompt << "I specialize in #{agency_preferred_niche}, "
    end
    if current_agency.agency_profile.estd_date.present?
      agency_estd_date = current_agency.agency_profile.estd_date
      @gpt_prompt << "Date our Agency was Established in #{agency_estd_date}, "
    end

    if current_agency.agency_profile.core_services.present?
      agency_core_services = current_agency.agency_profile.core_services
      @gpt_prompt << "Our Core Services are #{agency_core_services}, "
    end

    if current_agency.agency_profile.value_proposition.present?
      agency_value_proposition = current_agency.agency_profile.value_proposition
      @gpt_prompt << "Our Unique Value Proposition is #{agency_value_proposition}, "
    end

    @gpt_prompt << 'I am prospecting '
    if @direct_lead.name.present?
      company_name = @direct_lead.name
      @gpt_prompt << "a company called #{company_name}, "
    end

    if params[:first_name].present?
      @gpt_prompt << "their first name is #{params[:first_name]}, "
    end

    if params[:last_name].present?
      @gpt_prompt << "their last name is #{params[:last_name]}, "
    end

    if @direct_lead.base_domain.present?
      domain = @direct_lead.base_domain
      @gpt_prompt << "their website address is #{domain}, "
    end

    if params[:city].present?
      @gpt_prompt << "their city is #{params[:city]}, "
    end

    if params[:instagram].present?
      @gpt_prompt << "their instagram is #{params[:instagram]}, "
    end

    @gpt_prompt << params[:icebreaker_sentence]

    client = Openai.authorization_uri
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: @gpt_prompt,
        max_tokens: 1000
    })

    content = []
    if response["choices"].present?
      content = response["choices"].map { |c| c["text"] }
    end
    render json: { status: 200, data: { content: content.to_json } }
  end

  def agency_email_subdomain_blank?
    current_agency.cold_email_sub_domain.blank?
  end

  def from_email_name_blank?(contact)
    contact.direct_lead.lead_source.from_email_name.blank?
  end

  def draft_mail
    @lead_source = @direct_lead&.lead_source
    contact = @direct_lead.contacts.find_or_create_by(email: params[:email])

    if contact.nil?
      count_details = direct_lead_email_count_details(@lead_source)
      return render json: {
        status: 400,
        count: count_details[:count],
        remain_email_count: count_details[:remain_email_count],
        message: "Email #{params[:email]} is not present in your contact list."
      }
    end

    if agency_email_subdomain_blank?
      count_details = direct_lead_email_count_details(@lead_source)
      return render json: {
        status: 400,
        count: count_details[:count],
        remain_email_count: count_details[:remain_email_count],
        message: 'To send emails, please add a subdomain.'
      }
    end

    if from_email_name_blank?(contact)
      count_details = direct_lead_email_count_details(@lead_source)
      return render json: {
        status: 400,
        count: count_details[:count],
        remain_email_count: count_details[:remain_email_count],
        message: 'To send emails, please add a from email name.'
      }
    end

    contact.email = params[:email]
    contact.first_name = params[:first_name]
    contact.last_name = params[:last_name]
    contact.phone = params[:phone] if params[:phone].present?
    contact.base_domain = @direct_lead.base_domain
    contact.save

    wordpress_content = if @direct_lead.wordpress?
      contact.next_template.wordpress_site_custom_content
    else
      ''
    end

    @liquid_template = Liquid::Template.parse(params[:body])
    email_body = @liquid_template.render(
      'first_name' => params[:first_name],
      'domain' => @direct_lead.base_domain,
      'company_name' => @direct_lead.name,
      'instagram' => params[:instagram],
      'variable_1' => params[:variable_1],
      'variable_2' => params[:variable_2],
      'variable_3' => params[:variable_3],
      'prompt_1' => params[:prompt_1],
      'prompt_2' => params[:prompt_2],
      'prompt_3' => params[:prompt_3],
      'city' => params[:city],
      'intro' => params[:intro],
      'tomorrow' => EmailLeadDynamicVariableService.new.next_two_working_days,
      'wordpress' => wordpress_content
    )

    msg = "Email already sent"

    if contact.email.include?("clickx.io")
      sent_mail_obj = contact.sent_emails.create(
        content: email_body,
        subject: LeadHelper.mail_subject(contact, contact.next_template)
      )
      email_status = contact.clickx_user_send(current_user, sent_mail_obj)
      # msg = "Failed to send email"
      if email_status
        msg = "Email send successfully"
      end
    elsif current_agency.email_leads_count_limit <= current_agency.send_email_leads_count
      msg = "Email Limit Exceeded"
    elsif contact.persisted?
      sent_mail_obj = contact.sent_emails.create(
        content: email_body,
        subject: LeadHelper.mail_subject(contact, contact.next_template)
      )
      email_status = contact.verify_and_send(current_user, sent_mail_obj)
      if email_status
        msg = "Email send successfully"
        current_agency.send_email_leads_count = current_agency.send_email_leads_count.to_i + 1
        current_agency.save
        @lead_source.send_email_leads_count = @lead_source.send_email_leads_count + 1
        @lead_source.save
      else
        msg = "Failed to send email"
      end
    end

    count = current_user.lead_contacts_emailed_today.count
    remain_email_count = @lead_source.total_email_leads_count - @lead_source.send_email_leads_count

    if contact.persisted?
      render json: { status: 200, count: count,
                     remain_email_count: remain_email_count,
                     message: msg }
    else
      render json: {
        status: 200, count: count,
        remain_email_count: remain_email_count,
        message: contact.errors.full_messages.to_sentence
      }
    end
  end

  def direct_lead_email_count_details(lead_source)
    count = current_user.lead_contacts_emailed_today.count
    remain_email_count = lead_source.total_email_leads_count - lead_source.send_email_leads_count
    { count: count, remain_email_count: remain_email_count }
  end

  def list_contacts
    @contacts = @direct_lead.contacts.order(:first_name)
  end

  def new_contact
    @contact = @direct_lead.contacts.new
  end

  def create_contact
    @contact = @direct_lead.contacts.create(contact_params)
    @status = true
    @message = if @contact.persisted?
      lead_source = @direct_lead.lead_source
      lead_source.total_email_leads_count = lead_source.total_email_leads_count + 1
      lead_source.save
      'Contact created successfully'
    else
      @status = false
      @contact.errors.full_messages.to_sentence
    end
  end

  def edit_contact; end

  def update_contact
    @status = true
    if @contact.update_attributes(contact_params)
      @message = 'Contact updated successfully'
    else
      @status = false
      @message = @contact.errors.full_messages.to_sentence
    end
    @contacts = @direct_lead.contacts.order(:first_name)
  end

  def delete_contact
    @status = true
    if @contact.destroy
      lead_source = @direct_lead.lead_source
      lead_source.total_email_leads_count = lead_source.total_email_leads_count - 1
      lead_source.save
      @message = 'Contact removed successfully'
    else
      @status = false
      @message = @contact.errors.full_messages.to_sentence
    end
    @contacts = @direct_lead.contacts.order(:first_name)
  end

  def create_from_clickx
    lead = @lead_source.direct_leads.find_by(base_domain: params[:domain])
    raise 'Lead already exists' if lead

    @lead_source.direct_leads.create(
      name: params[:domain], base_domain: params[:domain]
    )
  rescue StandardError => e
    @error = e
  end

  def import_from_d7
    D7Importer.import(params[:result_id], params[:lead_source_id])

    redirect_back(fallback_location: direct_leads_path,
                  notice: 'Leads Imported Successfully')
  end

  def emailed
    lead_source_ids = current_agency.lead_sources.pluck(:id)
    @emails_leads = []
    return if lead_source_ids.blank?

    @emails_leads =
      if params[:search].present?
        DirectLead.emailed.order_by_last_sent_email
                  .with_lead_source(lead_source_ids)
                  .where('direct_leads.base_domain ILIKE :query ', query: "%#{params[:search]}%")
                  .includes(:contacts, :sent_emails)
                  .references(:contacts)
      else
        DirectLead.emailed.order_by_last_sent_email
                  .with_lead_source(lead_source_ids)
                  .includes(:contacts, :sent_emails)
                  .references(:contacts)
      end
  end

  def contacts
    @contacts = @direct_lead.contacts.includes(sent_emails: [:sender, :verifier]).order(:first_name)
  end

  def convert
    @direct_lead.toggle!(:converted)
  end

  def reject
    if @direct_lead.rejected?
      @direct_lead.update(
        rejected_at: nil,
        rejected_by: current_user.id
      )
    else
      @direct_lead.update(
        rejected_at: DateTime.current,
        rejected_by: current_user.id
      )
    end

    redirect_to agency_single_direct_lead_path(lead_source_id: params[:lead_source_id])
  end

  def change_lead_source
    @direct_lead.update_columns(lead_source_id: @lead_source.id)
  end

  def import_from_csv
    lead_source = LeadSource.find_by_id(params[:lead_source_id])
    lead_source_file = lead_source.lead_source_files.create(filename: params[:csv_file]) if lead_source.present?
    status = ImportDirectLeadsFromCsv.import(
      params[:lead_source_id], lead_source_file.filename.url, false
    )
    if status
      flash[:success] = 'Leads Imported'
    else
      flash[:error] = 'The file format is invalid'
    end
    redirect_back(
      fallback_location: agency_lead_sources_path
    )
  end

  def add_to_negative_domains_list
    @lead = DirectLead.find(params[:id]) rescue nil
    return if @lead.blank?
    lead_source = @lead.lead_source
    lead_source.total_email_leads_count = lead_source.total_email_leads_count - 1
    lead_source.save
    # NegativeDomain.create(name: @lead.base_domain, ignored: true)
    @lead.destroy
    redirect_to agency_single_direct_lead_path(lead_source_id: lead_source.id)
  end

  private

  def set_direct_lead
    @direct_lead = DirectLead.find(params[:id])
  end

  def set_contact
    @contact = @direct_lead.contacts.find(params[:contact_id])
  end

  def lead_params
    params.require(:direct_lead).permit(:name, :lead_source_id)
  end

  def set_lead_source
    @lead_source = LeadSource.find(params[:lead_source_id])
  end

  def contact_params
    params.require(:domain_contact).permit(:first_name, :last_name, :company, :title, :email, :instagram, :phone, :city)
  end

  def set_liquid_template(contact)
    return '' if contact.blank?

    email_template = contact.next_template
    wordpress = if @direct_lead.wordpress?
      email_template.wordpress_site_custom_content
    else
      ''
    end

    screenshot =
      @direct_lead.screenshot_image.blank? ? '' : "<img src='#{@direct_lead.screenshot_image.url}' width='400' height='350' alt='' />"

    @liquid_template = Liquid::Template.parse(email_template.content)
    @template = @liquid_template.render(
      'first_name' => '{{first_name}}',
      'lead_source_name' => @lead_source.name,
      'domain' => @direct_lead.base_domain,
      'company_name' => '{{company_name}}',
      'instagram' => '{{instagram}}',
      'variable_1' => '{{variable_1}}',
      'variable_2' => '{{variable_2}}',
      'variable_3' => '{{variable_3}}',
      'prompt_1' => '{{prompt_1}}',
      'prompt_2' => '{{prompt_2}}',
      'prompt_3' => '{{prompt_3}}',
      'city' => '{{city}}',
      'intro' => '{{intro}}',
      'tomorrow' => EmailLeadDynamicVariableService.new.next_two_working_days,
      'wordpress' => wordpress,
      'screenshot' => screenshot
    )
  end

  def negative_domain?(base_domain)
    return if NegativeDomain.find_by(name: base_domain).blank?

    @message = 'This domain was ignored'
  end

  def root_and_base_urls(url)
    @root_url = URI.parse(url).scheme.nil? ? "http://#{url}" : url
    @base_url = URI.parse(@root_url).host.downcase
    @base_domain = @base_url.start_with?('www.') ? @base_url[4..-1] : @base_url
    negative_domain?(@base_domain) and return
    @url_params =
      { root_url: @root_url, base_url: @base_url, base_domain: @base_domain }
  end

  def perform_authorization
    authorize :direct_lead
  end

  def set_lead_source_by_domain
    @lead_source = LeadSource.find_or_create_by(name: 'Clickx Competitors')
  end

  def validate_required_fields
    missing_fields = []
    missing_fields.push('Email') if params[:email].blank?
    missing_fields.push('Email Content') if params[:body].blank?

    if missing_fields.any?
      render json: {
        status: 401,
        message: "#{missing_fields.join(', ')} are required."
      } and return
    end
  end
end
