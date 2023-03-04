class CreateSubscriptionCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_coupons do |t|
      t.string :coupon_id
      t.string :duration
      t.integer :amount_off
      t.string :currency, default: 'USD'
      t.integer :duration_in_months
      t.integer :max_redemptions
      t.integer :percent_off
      t.datetime :redeem_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
