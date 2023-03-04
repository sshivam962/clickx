class ChangeColumnsOfPardotAuth < ActiveRecord::Migration[5.1]
  def up
    remove_column :pardot_auths, :password
    remove_column :pardot_auths, :user_key

    add_column :pardot_auths, :encrypted_user_key, :string
    add_column :pardot_auths, :encrypted_user_key_iv, :string
    add_column :pardot_auths, :encrypted_password, :string
    add_column :pardot_auths, :encrypted_password_iv, :string
  end

  def down
    remove_column :pardot_auths, :encrypted_user_key
    remove_column :pardot_auths, :encrypted_user_key_iv
    remove_column :pardot_auths, :encrypted_password
    remove_column :pardot_auths, :encrypted_password_iv

    add_column :pardot_auths, :password, :string
    add_column :pardot_auths, :user_key, :string
  end
end
