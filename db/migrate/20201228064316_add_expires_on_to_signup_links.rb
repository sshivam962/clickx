class AddExpiresOnToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :expires_on, :date
  end
end
