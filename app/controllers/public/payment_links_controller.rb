# frozen_string_literal: true

class Public::PaymentLinksController < PublicController
  layout 'public/payment_link'

  before_action :set_payment_link
  before_action :set_agency
  before_action :ensure_access
  before_action :set_user_info

  def show; end

  def subscribe
    ActiveRecord::Base.transaction do
      if @payment_link.plan.present?
        set_stripe_customer
        set_stripe_card
        PaymentLinkSubscribeService.process(
          payment_link: @payment_link,
          card_token: params[:card_token],
          stripe_customer: @customer
        )
      else
        raise 'Payment Link Expired'
      end
    end
  rescue StandardError => e
    ErrorNotify.payment_link_error(params.except(:billing, :expiry, :number, :cvc).as_json, e.message).deliver_now
    @error = 'Please enter a valid card.'
  end

  def error; end

  private

  def set_payment_link
    @payment_link ||= PaymentLink.enabled.find_by(id: params[:id])
  end

  def set_agency
    @agency = @payment_link&.agency
  end

  def ensure_access
    return if @payment_link && @agency&.payment_links_enabled?

    @error = 'Payment Link Expired'
    render :error
  end

  def set_stripe_customer
    @customer = Stripe::Customer.create(
      {
        email: @user_info[:email],
        description: customer_details
      },
      api_key: @agency.stripe_credential.secret_key
    )
    @payment_link.update(stripe_customer_id: @customer.id)
  end

  def set_stripe_card
    @card = Stripe::Customer.create_source(
      @customer.id,
      { source: params[:card_token] },
      api_key: @agency.stripe_credential.secret_key
    )
  end

  def customer_details
    @user_info.map { |k, v| "#{k.to_s.titleize} : #{v}" }.join(', ')
  end

  def set_user_info
    @user_info = @payment_link.user_info
  end
end
