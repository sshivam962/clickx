class AddStripeCustomerIdToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :stripe_customer_id, :string
  end
end
