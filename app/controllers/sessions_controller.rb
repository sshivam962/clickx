# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def new
    set_flash_message(:notice, cookies[:sign_out_reason]) if cookies[:sign_out_reason].present?
    cookies.delete(:sign_out_reason)

    clear_all_user_cookies
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    # End user session if its a business user & manages only one campaign which is expired
    if resource&.business_user? && resource.businesses.count.eql?(1)
      campaign = resource.businesses.last
      if campaign.trial_expired?
        cookies[:sign_out_reason] = 'trial_expired'
        sign_out(resource)
        redirect_to new_user_session_path and return
      end
    end

    if resource&.super_admin? && white_labeled_client
      set_flash_message(:notice, :admin_login_in_white_label_url) if is_flashing_format?
      cookies[:sign_out_reason] = 'admin_login_in_white_label_url'
      sign_out(resource)
      redirect_to new_user_session_path and return
    end

    if resource&.agency_admin? && (white_labeled_client && (resource.ownable_id != white_labeled_client.id)) || (resource.ownable_agency && resource.ownable_agency.agency_status == false)
      set_flash_message(:notice, :wrong_white_labeled_agency) if is_flashing_format?
      cookies[:sign_out_reason] = 'wrong_white_labeled_agency'
      sign_out(resource)
      redirect_to new_user_session_path and return
    end

    if resource&.contractor? && !resource.admin_approved?
      set_flash_message(:notice, :contractor_account_verfication) if is_flashing_format?
      cookies[:sign_out_reason] = 'contractor_account_verfication'
      sign_out(resource)
      redirect_to new_user_session_path and return
    end

    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def white_labeled_client
    Agency.white_labelled.find_by(domain: request.host_with_port)
  end
end
