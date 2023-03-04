class CreateLeadsInEmailProspecting
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
      @url_params = root_and_base_urls(row['company_domain']) 
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
      @contact = @lead.contacts.where(email: row['email']).first
      unless @contact
        @contact = @lead.contacts.new(email: row['email'])
        @contact.assign_attributes(contact_attrs(row))
        if @contact.save
          @lead_source.total_email_leads_count = @lead_source.total_email_leads_count + 1
        end
      else
        @contact.assign_attributes(contact_attrs(row))
        @contact.save
      end
      image_status = @lead.screenshot_image.present? || WebSiteScreenshotService.verify_image(@lead)
      @lead_source.update(remaining_count: remaining_count)
      Rails.logger.info "remain count #{remaining_count}"
    end
  end

  def lead_attrs row
    {
      base_domain: @url_params[:base_domain],
      name: row['company_name'],
      wordpress: Website.wordpress?(@url_params[:root_url]),
    }
  end

  def contact_attrs row
    {
      first_name:  row['first_name'],
      last_name: row['last_name'],
      title:  row['title'],
      company: row['company_name'],
      base_domain: @url_params[:base_domain],
      phone: row['phone_number'],
      instagram: row['instagram'],
      city: row['city'],
      created_type: 1
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
    rescue => e
      @url_params = {}
    end     
  end

  def negative_domain?(base_domain)
    NegativeDomain.exists?(name: base_domain)
  end
end  
