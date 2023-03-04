StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.created' do |event|
    # 1. new subscription created
    sync_subscriction event
  end

  events.subscribe 'customer.subscription.updated' do |event|
    # 1. subscription info updated
    sync_subscriction event
  end

  events.subscribe 'customer.subscription.trial_will_end' do |event|
    # 1. subscription about to end trial
    sync_subscriction event
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    # 1. subscription cancelled
    sync_subscriction event
  end
end

def sync_subscriction event
  event_type = event.type.delete('customer.subscription.')
  @business = Business.find_by(customer_id: event.data.object.customer)
  if @business
    if event_type == 'deleted'
      set_free_service event
    else
      SubscriptionService.process(event.data.object)
    end
  else
    AgencyStripeService.process({
      data: event.data.object,
      event_type: event_type
    })
  end
end

def set_free_service event
  @subscription = Subscription::Account.find_by(id: event.data.object.id)
  return unless @subscription&.set_as_free

  @business.update_attributes(free_service: true)
end
