class CloseApi
  def initialize(api_key = nil)
    @api_key = api_key.presence || ENV['CLOSE_API_KEY_PRIMARY']
  end

  def self.method_missing(m, *args, &block)
    if method_defined? m
      new.send(m, *args, &block)
    else
      super
    end
  end

  def client
    utc_offset =
      ActiveSupport::TimeZone['America/Chicago'].now.utc_offset / 1.hour
    @client ||= Closeio::Client.new(@api_key, utc_offset: utc_offset)
  end

  def me
    client.me
  end

  def sequence_subscriptions(attrs)
    client.list_sequence_subscriptions(attrs)
  end

  def sequence_subscription(id)
    client.find_sequence_subscription(id)
  end

  def update_seq_subscription(id, attrs)
    client.update_sequence_subscription(id, attrs)
  end

  def create_sequence_subscription(attrs)
    client.create_sequence_subscription(attrs)
  end

  def fetch_sequences
    client.list_sequences['data']
  end

  def sequence(id)
    client.find_sequence(id)
  end

  def fetch_lead_statuses
    data = client.list_lead_statuses['data']
    data.sort { |x, y| [y['label'], y['type']] <=> [x['label'], x['type']] }
  end

  def fetch_opportunity_statuses
    data = client.list_opportunity_statuses['data']
    data.sort { |x, y| [y['label'], y['type']] <=> [x['label'], x['type']] }
  end

  def fetch_leads(query, page: 1, limit: 200)
    offset = (page - 1) * limit
    client.list_leads(query, false, nil, _limit: limit, _skip: offset)
  end

  def fetch_leads_with_email(email, page: 1, limit: 200)
    if email.present?
      fetch_leads("email_address:\"#{email}\"", page: page, limit: limit)
    else
      {
        "has_more": false,
        "total_results": 0,
        "data": []
      }
    end
  end

  def fetch_lead(id)
    client.find_lead(id)
  end

  def create_lead(attrs)
    client.create_lead(attrs)
  end

  def delete_lead(id)
    client.delete_lead(id)
  end

  def update_lead(lead_id, attrs)
    client.update_lead(lead_id, attrs)
  end

  def create_note(lead_id, note)
    client.create_note(lead_id: lead_id, note: note)
  end

  def fetch_activity_report(user_id, date_start, date_end)
    @date_start = DateHelpers.iso8601(date_start.beginning_of_day.utc)
    @date_end = DateHelpers.iso8601(date_end.end_of_day.utc)

    client.activity_report(
      ENV['CLOSE_ONEIMS_ORG_ID'],
      user_id: user_id,
      date_start: @date_start,
      date_end: @date_end
    )
  end

  def fetch_activities(attrs = {})
    client.list_activities(attrs)
  end

  def fetch_opportunity_status_changes(attrs = {})
    client.list_opportunity_status_changes(attrs)
  end

  def webhooks
    client.list_webhooks['data']
  end

  def create_webhook(attrs = {})
    client.create_webhook(attrs)
  end

  def delete_webhook(id)
    client.delete_webhook(id)
  end

  def fetch_emails(attrs = {})
    page = attrs[:page] || 1
    attrs[:_limit] = 100
    attrs[:_skip] = (page - 1) * attrs[:_limit]

    if attrs[:date_created__gt]
      attrs[:date_created__gt] =
        DateHelpers.iso8601(attrs[:date_created__gt].beginning_of_day.utc)
    end
    client.list_emails(attrs)
  end

  def fetch_active_users
    my_acc = client.me
    org_id = my_acc['email_accounts'] ? my_acc['email_accounts'][0]['organization_id'] : nil
    return unless org_id

    client.find_organization(org_id)['memberships']
  end

  def create_task(attrs = {})
    client.create_task(attrs)
  end

  def task_list(attrs = {})
    client.list_tasks(attrs)
  end

  def fetch_custom_field(id)
    client.find_custom_field(id)
  end

  def fetch_contact(id)
    client.find_contact(id)
  end

  def create_contact(attrs)
    client.create_contact(attrs)
  end

  def update_contact(contact_id, attrs)
    client.update_contact(contact_id, attrs)
  end

  def delete_contact(id)
    client.delete_contact(id)
  end

  def email_activities(lead_id, page: 1, limit: 100)
    offset = (page - 1) * limit
    client.list_emails(lead_id: lead_id, _limit: limit, _skip: offset, __order_by: :date_created)
  end

  def note_activities(lead_id, page: 1, limit: 100)
    offset = (page - 1) * limit
    client.list_notes(lead_id: lead_id, _limit: limit, _skip: offset)
  end

  def fetch_smart_view(id)
    client.find_smart_view(id)
  end

  def fetch_smart_views
    client.list_smart_views
  end
end
