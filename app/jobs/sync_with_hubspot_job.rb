# frozen_string_literal: true

class SyncWithHubspotJob
  include Sidekiq::Worker

  def perform(user_id, payment_link_sent = false)
    @user = User.find_by(id: user_id)
    return unless @user
    return unless @user.normal?
    return unless @user.ownable_type.eql?('Agency')
    @payment_link_sent = payment_link_sent

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: Rails.application.routes.url_helpers.auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    Hubspot::Contact.create_or_update(@user.email, contact_properties)
  rescue Hubspot::RequestError => e
    ErrorNotify.sync_with_hubspot(@user, e.message).deliver_now
  end

  private

  def contact_properties
    dfyelite = @user.ownable.labels&.include?('DFYElite') ? 'Yes' : 'No'
    scale_program = @user.ownable_agency.scale_program ? 'Yes' : 'No'

    properties = {
      email: @user.email,
      firstname: @user.first_name,
      lastname: @user.last_name,
      clickx_agency_partner_user: 'Yes',
      dfyelite: dfyelite,
      scale_program: scale_program
    }
    properties[:payment_link_sent] = 'Yes' if @payment_link_sent
    properties
  end
end
