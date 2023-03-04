class RemoveNutshellFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :nutshell_service, :boolean, default: false
    drop_table :nutshell_auths do |t|
      t.string :email
      t.string :encrypted_api_key
      t.integer :business_id
      t.string :encrypted_api_key_iv

      t.timestamps
    end
  end
end
