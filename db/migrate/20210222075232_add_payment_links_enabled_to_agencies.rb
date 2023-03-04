class AddPaymentLinksEnabledToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :payment_links_enabled, :boolean, default: false
  end
end
