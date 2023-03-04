module BusinessStripeManager
  extend ActiveSupport::Concern

  private

  def credit_card_attrs
    {
      object: 'card',
      exp_month: params[:card][:expiry].split('/').map(&:strip).first,
      exp_year: params[:card][:expiry].split('/').map(&:strip).second,
      name: params[:card][:name],
      number: params[:card][:number],
      address_city: params[:card][:address_city],
      address_country: params[:card][:address_country],
      address_line1: params[:card][:address_line1],
      address_line2: params[:card][:address_line2],
      address_state: params[:card][:address_state],
      address_zip: params[:card][:address_zip],
      cvc: params[:card][:cvc]
    }
  end

  def customer_details
    user_params = params.require(:card).permit(:name)
                        .as_json.map { |k, v| "#{k.to_s.titleize} : #{v}" }
                        .join(', ')
    [
      user_params,
      "Business : #{current_business.name}"
    ].select(&:present?).join(', ')
  end

  def create_stripe_customer
    @customer = Stripe::Customer.create(
      email: current_user.email,
      description: customer_details
    )
    unless current_business.update_attributes(customer_id: @customer.id)
      render json: {
        status: 401, data: nil,
        message: current_business.errors.full_messages.to_sentence
      } and return
    end
    @customer
  end

  def setup_payment_method
    if params[:selected_card] == 'add_card'
      card = @customer.sources.create(source: credit_card_attrs)
      @customer.default_source = card.id
    else
      @customer.default_source = params[:selected_card]
    end
    @customer.save
  end

  def ensure_payment_method
    @customer.default_source = params[:card_id]
    @customer.save
  end

  def set_customer
    @customer = current_business.stripe_customer
    create_stripe_customer if !@customer || @customer.deleted?
  end
end
