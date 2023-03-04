class CreatePardotAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :pardot_auths do |t|
      t.string :email,        null: false
      t.string :password,     null: false
      t.string :user_key,       null: false
      t.integer :business_id, null: false
      t.timestamps null: false
    end
  end
end
