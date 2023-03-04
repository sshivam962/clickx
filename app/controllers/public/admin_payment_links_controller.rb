# frozen_string_literal: true

class Public::AdminPaymentLinksController < PublicController
  layout 'public/payment_link'

  before_action :set_admin_payment_link
  before_action :ensure_access
  before_action :set_user_info

  def show; end

  def subscribe
    ActiveRecord::Base.transaction do
      if @payment_link.admin_plan.present?
        set_stripe_customer
        set_stripe_card
        AdminPaymentLinkSubscribeService.process(
          payment_link: @payment_link,
          card_token: params[:card_token],
          stripe_customer: @customer
        )
      else
        redirect_to 'https://www.clickx.io/contact-us/?utm_source=expiredlink&utm_medium=crm'
      end
    end
  rescue StandardError => e
    ErrorNotify.payment_link_error(params.except(:billing, :expiry, :number, :cvc).as_json, e.message).deliver_now
    @error = 'Please enter a valid card.'
  end

  def error; end

  private

  def set_admin_payment_link
    @payment_link = AdminPaymentLink.find_by(id: params[:id])
  end

  def set_agency
    @agency = @payment_link&.agency
  end

  def ensure_access
    return if @payment_link && @payment_link.enabled?

    redirect_to 'https://www.clickx.io/contact-us/?utm_source=expiredlink&utm_medium=crm'
  end

  def set_stripe_customer
    @customer = Stripe::Customer.create(
      {
        email: @user_info[:email],
        description: customer_details
      }
    )
    # @payment_link.update(stripe_customer_id: @customer.id)
  end

  def set_stripe_card
    @card = Stripe::Customer.create_source(
      @customer.id,
      { source: params[:card_token] }
    )
  end

  def customer_details
    @user_info.map { |k, v| "#{k.to_s.titleize} : #{v}" }.join(', ')
  end

  def set_user_info
    @user_info = @payment_link.user_info
  end
end
