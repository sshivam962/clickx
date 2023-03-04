class RemoveOnetimeChargeSubscriptionFromSignupLinks < ActiveRecord::Migration[5.1]
  def change
    remove_column :signup_links, :onetime_charge_subscription
  end
end
