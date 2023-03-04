class AddEncryptedApiKeyIvToNutshellAuth < ActiveRecord::Migration[5.1]
  def change
    add_column :nutshell_auths, :encrypted_api_key_iv, :string
  end
end
