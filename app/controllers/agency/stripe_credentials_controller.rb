# frozen_string_literal: true

class Agency::StripeCredentialsController < Agency::BaseController
  before_action :set_stripe_credential
  before_action :build_agency, only: :index

  def create
    test_stripe_credential
    @credential.update(credential_params)
    @credential.agency.update_attributes(t_and_c_link: params["stripe_credential"]["agency"]["t_and_c_link"])
  rescue Exception => e
    @error = e.message
  end

  private

  def set_stripe_credential
    @credential =
      current_agency.stripe_credential || current_agency.build_stripe_credential
  end

  def credential_params
    #params.require(:stripe_credential).permit(:publishable_key, :secret_key)
    params.require(:stripe_credential).permit(:publishable_key, :secret_key,
       agency_attributes: [:id, :t_and_c_link])
  end

  def test_stripe_credential
    Stripe::Product.list({limit: 1}, api_key: credential_params[:secret_key])
  end
end
