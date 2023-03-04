class SuperAdmin::Integrations::HubspotController < ApplicationController
  layout 'base'

  def connect
    redirect_to HubspotAuth.authorization_uri(redirect_uri: auth_hubspot_callback_url)
  end

  def callback
    HubspotAuth.access_token(
      params[:code],
      redirect_uri: auth_hubspot_callback_url
    )

    redirect_to super_admin_integrations_path
  end
end
