class CreatePaymentLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_links, id: :uuid do |t|
      t.references :agency
      t.references :lead
      t.timestamps
    end
  end
end
