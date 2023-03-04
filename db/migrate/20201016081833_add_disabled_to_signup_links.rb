class AddDisabledToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :disabled, :boolean
  end
end
