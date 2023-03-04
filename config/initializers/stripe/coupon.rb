StripeEvent.configure do |events|
  events.subscribe 'coupon.created' do |event|
    # 1. new coupon created
    # 2. deleted from stripe and re-created
    create_or_update_coupon event
  end

  events.subscribe 'coupon.updated' do |event|
    # 1. coupon info updated
    # 2. coupon out of sync with db
    create_or_update_coupon event
  end

  events.subscribe 'coupon.deleted' do |event|
    coupon = Subscription::Coupon.find_by(coupon_id: event.data.object.id)
    coupon.destroy if coupon
  end
end

def create_or_update_coupon event
  coupon_data = event.data.object.to_h
  coupon = Subscription::Coupon.find_or_initialize_by(coupon_id: coupon_data[:id])
  coupon_attributes = coupon_data.slice(*Subscription::Coupon.coupon_columns)
  coupon_attributes.delete :id
  coupon.assign_attributes coupon_attributes
  coupon.redeem_by = coupon_data[:redeem_by] && Time.at(coupon_data[:redeem_by])
  coupon.save!
end
