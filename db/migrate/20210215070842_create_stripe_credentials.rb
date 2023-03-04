class CreateStripeCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_credentials do |t|
      t.string :publishable_key
      t.string :secret_key
      t.string :payment_links_product_id

      t.references :agency
      t.timestamps
    end
  end
end
