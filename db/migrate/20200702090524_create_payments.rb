class CreatePayments < ActiveRecord::Migration[5.1]
  def up
    create_table :payments do |t|
      t.string :stripe_id
      t.integer :amount, default: 0
      t.string :currency, default: 'usd'
      t.string :description
      t.string :customer
      t.string :interval
      t.string :status
      t.integer :billing_category
      t.jsonb :metadata

      t.bigint :agency_id
      t.bigint :business_id

      t.timestamps
    end

    PackageSubscription.find_each do |subscription|
      next if subscription.metadata.blank?

      Payment.create(
        stripe_id: subscription.account_id,
        agency_id: subscription.agency_id,
        business_id: subscription.business_id,
        amount: subscription.amount,
        customer: subscription.customer,
        status: subscription.status,
        billing_category: subscription.billing_category,
        description: (subscription.metadata['description'] || subscription.metadata['plan']['name']),
        metadata: subscription.metadata,
        created_at: Time.at(subscription['metadata']['created'])
      )
    end
  end

  def down
    drop_table :payments
  end
end
