class AddSubscriptionToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :onetime_charge_subscription, :boolean, default: false
  end
end
