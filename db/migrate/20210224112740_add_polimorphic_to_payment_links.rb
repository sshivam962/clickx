class AddPolimorphicToPaymentLinks < ActiveRecord::Migration[5.1]
  def up
    add_column :payment_links, :resource_id, :bigint
    add_column :payment_links, :resource_type, :string
    PaymentLink.find_each do |link|
      link.update(resource_id: link.lead_id, resource_type: 'Lead')
    end
    remove_column :payment_links, :lead_id, :bigint
  end

  def down
    add_column :payment_links, :lead_id, :bigint
    PaymentLink.where(resource_type: 'Lead').find_each do |link|
      link.update(lead_id: link.resource_id)
    end
    remove_column :payment_links, :resource_id, :bigint
    remove_column :payment_links, :resource_type, :string
  end
end
