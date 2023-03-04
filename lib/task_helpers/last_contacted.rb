module LastContacted
  def last_contacted_at agency
    @result = []
    users_email = agency.users.map {|user| user.email}

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: Rails.application.routes.url_helpers.auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )
    users_email.each do |email|
      begin
        last_contacted = Hubspot::Contact.find_by_email(email).notes_last_contacted
        timestamp = Time.at(last_contacted.to_i/1000).strftime('%d %b %Y, %I:%M %p')
        @result << timestamp
        break
      rescue
        next
      end
    end
    @result.first
  end
end
