class AddPaidFieldToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :paid, :boolean, default: false
  end
end
