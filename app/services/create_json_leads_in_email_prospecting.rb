class CreateJsonLeadsInEmailProspecting
  def initialize(params)
    @record_collections = params[:record_collections]
    @lead_source = params[:lead_source]
  end
  def self.process(*args)
    new(*args).perform
  end

  def perform
    @record_collections.each do |row|
      remaining_count = @lead_source.remaining_count - 1
      @url_params = root_and_base_urls(row['site'])
      next if @url_params.blank?
      @lead =
        @lead_source.direct_leads.where(
          root_url: @url_params[:root_url]
        ).first
      unless @lead
        @lead = @lead_source.direct_leads.new(root_url: @url_params[:root_url])
        @lead.assign_attributes(lead_attrs(row).merge(@url_params))
        @lead.save
      else
        @lead.assign_attributes(lead_attrs(row).merge(@url_params))
        @lead.save
      end
      row['emails'].each do |e|
        @contact = @lead.contacts.where(email: e["email"]).first
        # TODO: If contact email found then we have to update the data instead of insert
        unless @contact
          @contact = @lead.contacts.new(email: e["email"])
          @contact.assign_attributes(contact_attrs(row, e))
          if @contact.save
            @lead_source.total_email_leads_count = @lead_source.total_email_leads_count + 1
            @lead_source.update(remaining_count: remaining_count)
          end
        else
          @contact.assign_attributes(contact_attrs(row, e))
          @contact.save
        end
      end

      image_status = @lead.screenshot_image.present? || WebSiteScreenshotService.verify_image(@lead)
      @lead_source.update(remaining_count: remaining_count)
      Rails.logger.info "remain count #{remaining_count}"
    end
  end

  def lead_attrs(row)
    {
      base_domain: @url_params[:base_domain],
      name: row['company_name'],
      wordpress: Website.wordpress?(@url_params[:root_url]),
    }
  end

  def contact_attrs(row, e)
    {
      first_name: e["first_name"],
      last_name: e["last_name"],
      title: row['type'],
      company: row['company_name'],
      base_domain: @url_params[:base_domain],
      phone: row['phone_number'],
      instagram: row['instagram'],
      city: row['city'],
      created_type: 2
    }
  end

  def root_and_base_urls(url)
    begin
      @root_url = URI.parse(url).scheme.nil? ? "http://#{url}" : url
      @base_url = URI.parse(@root_url).host.downcase
      @base_domain = @base_url.start_with?('www.') ? @base_url[4..-1] : @base_url
      negative_domain?(@base_domain) and return
      @url_params =
        { root_url: @root_url, base_url: @base_url, base_domain: @base_domain }
    rescue StandardError => e
      @url_params = {}
    end
  end

  def negative_domain?(base_domain)
    return if NegativeDomain.find_by(name: base_domain).blank?

    @message = 'This domain was ignored'
  end
end
