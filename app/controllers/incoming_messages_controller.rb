class IncomingMessagesController < ActionController::Base
  def webhook
    sms_sender = Twillio::Contact.find_or_create_by(phone: params[:From])
    Twillio::Contact.find_or_create_by(phone: params[:To])

    chat_thread =
      Twillio::ChatThread.find_or_create_by(contact_phone: params[:From])

    sms = chat_thread.messages.create!(
      sid: params[:SmsSid],
      body: params[:Body],
      from: params[:From],
      to: params[:To],
      status: params[:SmsStatus]
    )

    chat_thread.update(unread: true)

    AdminMailer.incoming_sms_notification(sms, sms_sender).deliver_later

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    contact_phone = chat_thread.contact_phone[-10..-1] || chat_thread.contact_phone
    
    contact = Hubspot::Contact.search(contact_phone, options = {count: 1})
    if contact.resources.present?
      note_body = "Inbound SMS: " + params[:Body]
      contact_id = contact.resources.first.id
      Hubspot::EngagementNote.create!(contact_id, note_body, owner_id = nil, deal_id = nil)
      
    end
  end
end
