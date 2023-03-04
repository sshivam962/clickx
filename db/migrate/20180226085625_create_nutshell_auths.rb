class CreateNutshellAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :nutshell_auths do |t|
      t.string :email
      t.string :encrypted_api_key
      t.integer :business_id

      t.timestamps
    end
  end
end
