class AddFirstnameLastnameEmailCompanyToSignupLink < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :first_name, :string
    add_column :signup_links, :last_name, :string
    add_column :signup_links, :email, :string
    add_column :signup_links, :company, :string
  end
end
