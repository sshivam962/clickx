class CreateMailgunSubdomains < ActiveRecord::Migration[5.2]
  def change
    create_table :mailgun_subdomains do |t|
      t.string :sub_domain, null: false
      t.text :user_name_ciphertext, null: false
      t.text :password_ciphertext, null: false

      t.timestamps
    end
  end
end
