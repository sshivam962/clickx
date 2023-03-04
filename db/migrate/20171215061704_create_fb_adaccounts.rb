class CreateFbAdaccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_adaccounts do |t|
      t.string :account_id
      t.integer :business_id

      t.timestamps
    end
  end
end
