module LeadHelper
  module_function

  def site_audit_report(domain = nil, link = nil)
    if link.blank? || domain.blank?
      'Here is a preliminary analysis on {{domain}} : Click Here'
    else
      "Here is a preliminary analysis on #{domain}:
        <a target='_blank' href=#{link}>Click Here</a>"
    end
  end

  def screenshot(root_url)
    "<img src='https://api.site-shot.com/?userkey=#{ENV['SITESHOT_API_KEY']}&url=#{root_url}&width=1920&height=1080' width='400' height='225' alt='' />"
  end

  def mail_subject(contact, email_template)
    direct_lead = contact.direct_lead

    subject_line = email_template.subject || "Re: {{domain}}"

    liquid_subject = Liquid::Template.parse(subject_line)
    liquid_subject.render(
      'domain' => direct_lead.base_domain,
      'first_name' => contact.first_name,
      'company_name' => direct_lead.name,
      'lead_source_name' => direct_lead.lead_source.name
    )
  end

  def contact_name_from_email(lead, email)
    return if email.blank?

    lead['contacts'].map do |contact|
      emails = contact['emails'].map { |item| item['email'] }
      return contact['name'] if emails.include?(email)
    end
  end

  def parse_outreach_email_content(lead, content, attrs, render_type)
    result = fetch_outreach_values(lead, render_type, attrs)
    Liquid::Template.parse(content).render(
      'domain' => liquid_var_value(lead, 'domain') || '{{domain}}',
      'first_name' => result[:first_name] || '{{first_name}}',
      'company_name' =>
        liquid_var_value(lead, 'company_name') || '{{company_name}}',
      'screenshot' => result[:screenshot] || '{{screenshot}}',
      'sales_rep' => liquid_var_value(lead, 'sales_rep') || '{{sales_rep}}',
      'grader_url' => result[:grader_url] || '{{grader_url}}',
      'variable_1' => result[:variable_1] || '{{variable_1}}',
      'variable_2' => result[:variable_2] || '{{variable_2}}',
      'variable_3' => result[:variable_3] || '{{variable_3}}',
      'prompt_1' => result[:prompt_1] || '{{prompt_1}}',
      'prompt_2' => result[:prompt_2] || '{{prompt_2}}',
      'prompt_3' => result[:prompt_3] || '{{prompt_3}}',
      'intro' => result[:intro] || '{{intro}}',
    )
  end

  def validate_liquid_variables(lead, content, attrs)
    content = attrs[:body].concat(attrs[:subject]) if content.blank?
    result = { error: [] }
    OutreachEmailTemplate::LIQUID_VARS.each do |var|
      next unless content.include?(var)
      next if liquid_var_value(lead, var, attrs[:recipient_email]).present?

      result[:error].push(var.titleize)
    end
    result
  end

  def liquid_var_value(lead, var, contact_email = nil)
    case var
    when 'first_name'
      return if contact_email.blank?

      contact_name_from_email(lead, contact_email).split(' ').first
    when 'company_name'
      lead['name']
    when 'domain'
      base_domain(lead['url'])
    when 'screenshot'
      screenshot(lead['url']) if lead['url'].present?
    when 'sales_rep'
      find_sales_rep(lead)&.full_name
    end
  end

  def base_domain(url)
    root_url = URI.parse(url).scheme.nil? ? "http://#{url}" : url
    base_url = URI.parse(root_url).host.downcase

    base_url.start_with?('www.') ? base_url[4..-1] : base_url
  rescue
    url
  end

  def find_sales_rep(lead)
    return if lead['custom']['11 Sales Rep'].blank?

    CloseIOUser.find_by(uid: lead['custom']['11 Sales Rep'])
  end

  def default_outreach_values
    {
      first_name: '{{first_name}}',
      screenshot: '{{screenshot}}',
      grader_url: '{{grader_url}}',
      variable_1: '{{variable_1}}',
      variable_2: '{{variable_2}}',
      variable_3: '{{variable_3}}',
      prompt_1: '{{prompt_1}}',
      prompt_2: '{{prompt_2}}',
      prompt_3: '{{prompt_3}}',
      intro: '{{intro}}'
    }
  end

  def fetch_outreach_values(lead, render_type, attrs)
    return default_outreach_values if render_type.eql?('load')
    result = {}
    result[:first_name] =
      attrs[:first_name].presence ||
      liquid_var_value(lead, 'first_name', attrs[:recipient_email])
    result[:screenshot] = liquid_var_value(lead, 'screenshot')
    result[:grader_url] = attrs[:grader_url].presence
    result[:variable_1] = attrs[:variable_1].presence
    result[:variable_2] = attrs[:variable_2].presence
    result[:variable_3] = attrs[:variable_3].presence
    result[:prompt_1] = attrs[:prompt_1].presence
    result[:prompt_2] = attrs[:prompt_2].presence
    result[:prompt_3] = attrs[:prompt_3].presence
    result[:intro] = attrs[:intro].presence
    result
  end

  def build_filter_query(attrs)
    filter_keys = [
      'search',
      'smart_view',
      'lead_status',
      'opportunity_status',
      'last_communication_date',
      'sales_rep'
    ].freeze
    query = ''
    filter_keys.each do |filter_key|
      next if attrs[filter_key].blank?

      query += filter_query(filter_key, attrs[filter_key], attrs)
    end
    query.presence
  end

  def filter_query(key, values, attrs = {})
    q = ''
    case key
    when 'search'
      q = "#{values} "
    when 'lead_status'
      values.map { |value| q += "#{key}:\"#{value}\" " }
    when 'opportunity_status'
      values.map { |value| q += "#{key}:\"#{value}\" " }
    when 'last_communication_date'
      q += communication_date_filter_query(key, values, attrs[:custom_date])
    when 'smart_view'
      q += values
    when 'sales_rep'
      values.map { |value| q += "\"custom.11 Sales Rep\":\"#{value}\" " }
    end
    q
  end

  def communication_date_filter_query(key, value, custom_date = nil)
    if commn_date_custom_fields.include?(value) && custom_date
      custom_communication_date_query(key, value, custom_date)
    else
      "#{key}#{value}"
    end
  end

  def commn_date_custom_fields
    %w[before_date after_date on_date]
  end

  def custom_communication_date_query(key, value, custom_date)
    return if custom_date.blank?

    case value
    when 'before_date'
      "#{key} < #{Date.parse(custom_date).strftime('%F')}"
    when 'after_date'
      "#{key} > #{Date.parse(custom_date).strftime('%F')}"
    when 'on_date'
      "#{key}:#{Date.parse(custom_date).strftime('%F')}"
    end
  end

  def blocked_on_message lead
    if lead.blocked_at.present?
      "Blocked on #{lead.blocked_at.strftime("%b %d, %Y")}"
    end
  end
end
