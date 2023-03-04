class AddImplementationInvoiceIdToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :implementation_invoice_id, :string
  end
end
