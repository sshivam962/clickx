StripeEvent.configure do |events|
  events.subscribe 'subscription_schedule.aborted' do |event|
    # Occurs whenever a subscription schedule is canceled due to
    # the underlying subscription being canceled because of delinquency.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.canceled' do |event|
    # Occurs whenever a subscription schedule is canceled.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.completed' do |event|
    # Occurs whenever a new subscription schedule is completed.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.created' do |event|
    # Occurs whenever a new subscription schedule is created.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.expiring' do |event|
    # Occurs 7 days before a subscription schedule will expire.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.released' do |event|
    # Occurs whenever a new subscription schedule is released.
    sync_subscriction_schedule event
  end

  events.subscribe 'subscription_schedule.updated' do |event|
    # Occurs whenever a subscription schedule is updated.
    sync_subscriction_schedule event
  end
end

def sync_subscriction_schedule event
  SubscriptionScheduleService.process({
    data: event.data.object,
    event_type: event.type.delete('subscription_schedule.')
  })
end
