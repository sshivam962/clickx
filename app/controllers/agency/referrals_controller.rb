# frozen_string_literal: true

class Agency::ReferralsController < ActionController::Base

  before_action :set_plan, only: %i[create new]
  before_action :set_referrer, only: %i[create new]

  layout 'referral'

  def create
    AdminMailer.new_referral_signup_request(
      referral_params.as_json, @referrer, @plan
    ).deliver_now

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    Hubspot::Contact.create_or_update(
      referral_params[:email],
      contact_properties
    )
  end

  def new
    redirect_to root_path if @referrer.blank?
  end

  private

  def set_plan
    @plan = Package.growth.plans.find_by(key: params[:tier])
  end

  def user_exists?
    User.exists? email: user_params[:email]
  end

  def referral_params
    params.require(:referral).permit(:first_name, :company_name, :email, :phone)
  end

  def set_referrer
    @referrer = User.find_by(referral_code: params[:referral_code])
  end

  def contact_properties
    {
      email: params[:email],
      phone: params[:phone],
      firstname: params[:first_name],
      company: params[:company_name]
    }
  end
end
