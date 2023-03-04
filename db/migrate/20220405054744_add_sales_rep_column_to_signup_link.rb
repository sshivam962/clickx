class AddSalesRepColumnToSignupLink < ActiveRecord::Migration[5.1]
  def change
    add_reference :signup_links, :sales_rep, index: true, foreign_key: { to_table: :users }
  end
end
