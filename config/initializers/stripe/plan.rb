StripeEvent.configure do |events|
  events.subscribe 'plan.created' do |event|
    # 1. new plan created
    # 2. deleted from stripe and re-created
    # create_or_update_plan event
  end

  events.subscribe 'plan.updated' do |event|
    # 1. plan info updated
    # 2. plan out of sync with db
    # create_or_update_plan event
  end

  events.subscribe 'plan.deleted' do |event|
    plan = Subscription::Plan.find_by(plan_id: event.data.object.id)
    plan.destroy if plan
  end
end

def create_or_update_plan event
  plan_data = event.data.object.to_h

  plan = Subscription::Plan.find_or_initialize_by(plan_id: plan_data[:id])
  plan_attributes = plan_data.slice(*Subscription::Plan.plan_columns)
  plan_attributes.delete :id
  plan.assign_attributes plan_attributes
  plan.save!
end
