class RemovePardotFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    drop_table :pardot_auths do |t|
      t.string :email,        null: false
      t.string :encrypted_user_key,     null: false
      t.string :encrypted_user_key_iv,       null: false
      t.string :encrypted_password,     null: false
      t.string :encrypted_password_iv,       null: false
      t.integer :business_id, null: false
      t.timestamps null: false
    end

    remove_column :businesses, :pardot_service, :boolean, default: false
  end
end
