# frozen_string_literal: true

class Businesses::BillingController < ApplicationController
  before_action :set_customer, only: %i[subscribe update_card]

  def current_plan
    @account = current_business.active_subscription
    @trialing_account = current_business.trialing_subscription

    render json: {
      status: 200, data: {
        active: @account,
        downgraded: @trialing_account,
        set_as_free: @account&.set_as_free,
        free_start: @account&.current_period_end&.strftime('%m/%d/%y'),
        trial_end: @trialing_account&.trial_end&.strftime('%m/%d/%y'),
        has_costom_plan: current_business.custom_plan.present?
      }
    }
  end

  def fetch_cards
    cards =
      if current_business.customer_id
        @customer = current_business.stripe_customer
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
      end
    render json: { status: 200,
                   data: { cards: cards&.data, default_card: @customer&.default_source } } and return
  end

  def subscribe
    setup_payment_method
    active_subscription = current_business.active_subscription

    if active_subscription&.persisted?
      active_subscription.update_attributes(set_as_free: false)
      @stripe_sub = Stripe::Subscription.retrieve(
        active_subscription.account_id
      )

      if downgrading?
        subscription_starts_on_next_period
      else
        @stripe_sub.items = [{
          id: @stripe_sub.items.data[0].id,
          plan: params[:plan][:plan_id]
        }]

        @stripe_sub.save

        if current_business.trialing_subscription.present?
          @downgraded_subscription =
            Stripe::Subscription.retrieve(
              current_business.trialing_subscription.account_id
            )
          @downgraded_subscription.trial_end = @stripe_sub.current_period_end
          @downgraded_subscription.save
          SubscriptionService.process(subscription: @downgraded_subscription)

          @stripe_sub.delete(at_period_end: true)
        end
      end

    else
      @stripe_sub = Stripe::Subscription.create(
        customer: @customer.id,
        plan: params[:plan][:plan_id]
      )
    end

    current_business.remove_free_label
    SubscriptionService.process(subscription: @stripe_sub)

    render json: { status: 200,
                   data: {
                     current_subscription: current_business.active_subscription,
                     cards:  @customer.sources[:data].select{|source| source[:object].eql?('card')},
                     default_card: @customer.sources.retrieve(@customer&.default_source),
                     downgraded_subscription: current_business.trialing_subscription,
                     trial_end: current_business&.trialing_subscription&.
                   trial_end&.strftime('%m/%d/%y')
                   } }
  rescue Stripe::InvalidRequestError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  rescue Stripe::CardError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  def cancel_downgrade
    if current_business.active_subscription&.cancel_at_period_end

      subscription =
        Stripe::Subscription.retrieve(
          current_business.active_subscription&.account_id
        )
      subscription.items = [{
        id: subscription.items.data[0].id,
        plan: subscription.plan.id
      }]
      subscription.save

      if current_business.active_subscription.set_as_free
        current_business.active_subscription
                        .update_attributes(set_as_free: false)
      else
        downgraded_subscription =
          Stripe::Subscription.retrieve(
            current_business.trialing_subscription&.account_id
          )
        downgraded_subscription.delete
        current_business.trialing_subscription.destroy
      end
      render json: { status: 200, data: nil, message: 'Success' }

    else
      render json: { status: 401, data: nil, message: 'Something went wrong' }
    end
  rescue Stripe::InvalidRequestError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  def update_card
    setup_payment_method
    render json: {
      status: 200, data: {
        cards:  @customer.sources[:data].select{|source| source[:object].eql?('card')},
        default_card: @customer.sources.retrieve(@customer&.default_source)
      }
    }
  rescue Stripe::CardError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  def update_customer
    @business = Business.find(params[:business_id])
    @customer = Stripe::Customer.retrieve(params[:customer_id]) if params[:customer_id].present?

    if @customer
      if @business.update_attributes(customer_id: @customer.id)
        render json: {
          status: 200, data: @business.customer_id,
          message: 'Customer Id updated successfully'
        }
      else
        render json: {
          status: 401, data: nil,
          message: @business.errors.full_messages.to_sentence
        }
      end
    else
      render json: { status: 401, data: nil, message: 'Please enter a valid Customer Id' } and return
    end
  rescue Stripe::InvalidRequestError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  def add_subscription_account
    @stripe_sub = Stripe::Subscription.retrieve(params[:subscription_id])

    if !%w[active trialing].include? @stripe_sub.status
      render json: {
        status: 401, data: nil, message: 'Not an active subscription'
      } and return
    elsif @stripe_sub.customer != params[:customer_id]
      render json: {
        status: 401, data: nil,
        message: 'Not the subscription of specified customer'
      } and return
    end
    SubscriptionService.process(subscription: @stripe_sub)

    render json: { status: 200, data: nil, message: 'Subscription synced' }
  rescue Stripe::InvalidRequestError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  def subscribe_to_free
    @stripe_sub = Stripe::Subscription.retrieve(params[:subscription_id])
    @stripe_sub.delete(at_period_end: true)
    SubscriptionService.process(subscription: @stripe_sub)

    @trialing_account = current_business.trialing_subscription
    if @trialing_account
      downgraded_subscription =
        Stripe::Subscription.retrieve(
          @trialing_account&.account_id
        )
      downgraded_subscription.delete
      @trialing_account.destroy
    end

    current_business.active_subscription.update_attributes(set_as_free: true)

    render json: {
      status: 200, data: {
        free_start: Time.at(@stripe_sub.current_period_end)&.strftime('%m/%d/%y')
      },
      message: 'Success'
    }
  rescue Stripe::InvalidRequestError => e
    render json: {
      status: 401, data: nil, message: e.json_body[:error][:message]
    }
  end

  private

  def downgrading?
    plan =
      Subscription::Plan.find_by(plan_id: params[:plan][:plan_id])

    (plan.amount < current_business.active_subscription.amount) &&
      (plan.interval == current_business.active_subscription.interval)
  end

  def subscription_starts_on_next_period
    if current_business.trialing_subscription.present?
      Stripe::Subscription.retrieve(
        current_business.trialing_subscription.account_id
      ).delete
      current_business.trialing_subscription.destroy
    end
    @stripe_sub.delete(at_period_end: true)

    @downgraded_subscription = Stripe::Subscription.create(
      customer: @customer.id,
      items: [
        { plan: params[:plan][:plan_id] }
      ],
      trial_end: @stripe_sub.current_period_end
    )
    SubscriptionService.process(subscription: @downgraded_subscription)
  end

  def customer_details
    user_params = params.require(:card)
                        .permit(:first_name, :last_name, :email, :phone)
                        .as_json.map { |k, v| "#{k.to_s.titleize} : #{v}" }
                        .join(', ')
    [
      user_params,
      "Business : #{current_business.name}"
    ].select(&:present?).join(', ')
  end

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
    if params[:selected_card].present?
      @customer.default_source = params[:selected_card][:id]
    else
      card = @customer.sources.create(source: credit_card_attrs)
      @customer.default_source = card.id
    end
    @customer.save
  end

  def set_customer
    @customer = current_business.stripe_customer || create_stripe_customer
  end
end
